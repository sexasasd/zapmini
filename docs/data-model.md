# Modelo de dados (proposta) — ZapMini

Modelo proposto para **Cloud Firestore**. Ajustar conforme evolução do produto e requisitos de consulta/custo.

## Convenções

- IDs: `uid` (Auth do responsável), `childId`, `deviceId`, `conversationId`, `messageId`, `groupId`, etc.
- Timestamps: `createdAt`, `updatedAt`, `sentAt`, `deliveredAt`, `readAt` (server timestamps quando possível).
- Soft delete/retention: considerar flags e políticas de retenção para conformidade e controle parental.

## Coleções principais

### `guardians/{uid}`
Perfil e configurações do responsável (dono da conta familiar).
- `phoneNumber`, `displayName`, `photoUrl`
- `createdAt`, `updatedAt`
- `settings` (notificações, preferências)
- `consent` (registro de consentimento/termos aceitos, versão, data)

### `guardians/{uid}/children/{childId}`
Perfis infantis vinculados ao responsável (sem número de telefone).
- `displayName`, `photoUrl`, `birthYear` (ou faixa etária, conforme política de dados)
- `status` (active/suspended)
- `pinHash`/mecanismo de acesso local (se aplicável, com cuidado)
- `limits` (horários, restrições)
- `createdAt`, `updatedAt`

### `guardians/{uid}/devices/{deviceId}`
Dispositivos autorizados/pareados (responsável e/ou dispositivos dos perfis infantis).
- `profileType` (`guardian` | `child`)
- `childId` (quando `profileType=child`)
- `fcmToken`, `platform`, `appVersion`
- `lastSeenAt`, `createdAt`, `revokedAt`

### `usersIndex/{profileKey}` (opcional/auxiliar)
Índice para resolução de perfis/convites dentro da rede ZapMini (ex.: código público do perfil, QR token mapping). Evitar expor dados sensíveis.

### `contacts/{guardianUid}/approved/{contactId}`
Contatos aprovados no contexto familiar.
- `peerGuardianUid` ou `peerProfileKey`
- `peerChildId` (se contato for perfil infantil) / tipo de contato
- `displayNameAlias` (opcional)
- `status` (pending/approved/blocked)
- `approvedAt`, `createdBy`

### `invitations/{inviteId}`
Convites para conexão dentro do ZapMini.
- `fromGuardianUid`, `fromProfile` (guardian/child)
- `toTarget` (código/identificador dentro da rede)
- `status` (pending/accepted/expired/revoked)
- `expiresAt`, `createdAt`

### `conversations/{conversationId}`
Metadados da conversa (1:1 ou grupo).
- `type` (`direct` | `group`)
- `memberProfileKeys` / referências aos participantes
- `guardianScopes` (guardiões relacionados, para enforcement de políticas parentais)
- `lastMessage` (resumo: texto/tipo, `sentAt`, `senderKey`)
- `createdAt`, `updatedAt`

#### Subcoleção: `conversations/{conversationId}/members/{memberKey}`
- `role` (member/admin/guardian-viewer conforme modelo)
- `joinedAt`, `mutedUntil`, `lastReadAt`

#### Subcoleção: `conversations/{conversationId}/messages/{messageId}`
- `senderKey` (guardian ou child profile key)
- `type` (`text` | `image` | `audio` | `video` | `file` | `location` | `contact` | `system`)
- `text` (quando aplicável)
- `media` (objeto: `storagePath`, `mimeType`, `size`, `duration`, `thumbnailPath`, etc.)
- `replyToMessageId`, `forwardedFrom` (opcional)
- `status` (sent/delivered/read) ou mapas de recibo por membro
- `sentAt`, `editedAt`, `deletedFor`/flags

### `groups/{groupId}` (ou integrado em `conversations`)
Se separado, manter referência a `conversationId`.
- `name`, `photoUrl`, `description`
- `ownerGuardianUid`, `admins`
- `createdAt`, `updatedAt`

### `statuses/{guardianOrFamilyScope}/items/{statusId}` (fase futura)
- `authorKey`, `type` (text/image/video), `media`, `caption`
- `visibility` (contatos aprovados/subconjunto)
- `expiresAt`, `createdAt`

### `calls/{callId}` (fase futura)
- `conversationId`, `type` (`audio` | `video`)
- `initiatorKey`, `participants`
- `state` (ringing/active/ended/missed/declined)
- `startedAt`, `endedAt`, `signalingChannelRef`

## Regras de acesso (diretrizes)

- Um perfil infantil só acessa conversas/contatos permitidos pelo seu `guardianUid` e aprovações vigentes.
- Escritas de mensagem exigem membership ativo na conversa e perfil/dispositivo não revogado.
- Mídia no Storage deve ser legível apenas por membros autorizados da conversa/família.
- Operações administrativas (criar perfil infantil, aprovar contato, revogar dispositivo) restritas ao responsável autenticado.
- Validar invariantes críticas em Cloud Functions quando regras do Firestore não forem suficientes.

## Notas de evolução

- **E2EE:** exigirá armazenamento de metadados de chaves, envelopes cifrados e revisão do modelo de backups/histórico.
- **Multi-dispositivo avançado:** sincronização de sessões/chaves e recibos consistentes.
- **Escala:** avaliar sharding/particionamento de mensagens, limites de listeners e estratégias de arquivamento.
