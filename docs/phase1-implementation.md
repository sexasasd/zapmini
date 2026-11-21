# Fase 1 — Guia de implementação (MVP testável em família)

Este documento detalha a implementação da **Fase 1** do ZapMini: conta do responsável, perfis infantis sem número, pareamento de dispositivos, contatos aprovados, chat 1:1 (texto/áudio/imagem) e notificações push.

## 1. Objetivo e critérios de aceite

Ao final da Fase 1, uma família deve conseguir:
- Cadastrar o responsável via número de telefone
- Criar perfis infantis vinculados ao responsável (sem número)
- Parear o dispositivo da criança a um perfil infantil autorizado
- Convidar/aprovar contatos dentro da rede ZapMini
- Trocar mensagens 1:1 (texto, áudio, imagem) com recibos básicos
- Receber notificações push de novas mensagens/convites
- Gerenciar contatos permitidos e dispositivos a partir do perfil do responsável

## 2. Pré-requisitos (ação do usuário)

> Estas etapas dependem de ferramentas/contas externas e não puderam ser executadas automaticamente neste ambiente.

1. Instalar **Flutter SDK** e configurar toolchains (Android/iOS) — `flutter doctor`
2. Instalar **Firebase CLI** — `npm install -g firebase-tools`
3. Criar projeto no **Firebase Console** e ativar: Authentication (Phone), Firestore, Storage, Cloud Messaging, Cloud Functions
4. Gerar o app: `flutter create --org com.zapmini --project-name zapmini_app app`
5. Configurar FlutterFire: `flutterfire configure --project <PROJECT_ID>`
6. Copiar `firebase/.firebaserc.example` para `firebase/.firebaserc` com o `PROJECT_ID` e executar `firebase init`/`firebase deploy` conforme necessário

## 3. Estrutura sugerida do app (`app/lib/`)

```
lib/
  main.dart
  app.dart
  firebase_options.dart            # gerado pelo FlutterFire
  core/
    routing/                       # go_router: rotas e guards
    theme/                         # cores, tipografia, componentes
    constants/
    utils/
  shared/
    models/                        # Guardian, ChildProfile, Conversation, Message, Invite...
    repositories/                  # interfaces e implementações Firestore/Storage
    services/                      # auth, messaging (FCM), media upload, pairing
    widgets/                       # componentes reutilizáveis
  features/
    auth_guardian/                 # login/verificação por telefone do responsável
    family/                        # lista/criação de perfis infantis, pareamento
    contacts/                      # convites, aprovação/bloqueio
    chat/                          # lista de conversas, tela de chat 1:1, input de mídia
    settings/                      # painel do responsável, dispositivos, preferências
```

**Gerência de estado (sugestão):** Riverpod (`flutter_riverpod`) com providers por feature e repositórios injetáveis para facilitar testes.

## 4. Dependências Flutter sugeridas (Fase 1)

```bash
flutter pub add firebase_core firebase_auth cloud_firestore firebase_storage firebase_messaging cloud_functions
flutter pub add flutter_riverpod go_router
flutter pub add image_picker record file_picker cached_network_image
flutter pub add uuid intl permission_handler
```

Avaliar armazenamento seguro para tokens/sessão local do perfil pareado (ex.: `flutter_secure_storage`).

## 5. Modelos e fluxos principais

### 5.1 Responsável (Guardian)
- **Onboarding:** inserir número → receber OTP (Firebase Auth Phone) → verificar → criar/atualizar `guardians/{uid}`.
- **Pós-login:** acessar painel familiar (filhos, contatos, dispositivos).

### 5.2 Perfis infantis (sem número)
- **Criação (pelo responsável):** gravar `guardians/{uid}/children/{childId}` com nome/avatar e configurações básicas.
- **Acesso da criança:** não usa SMS próprio; usa pareamento autorizado:
  - Responsável gera código/QR de pareamento vinculado a `{uid, childId}` (com expiração)
  - Dispositivo da criança resgata o código → registra `guardians/{uid}/devices/{deviceId}` com `profileType=child`, `childId`, `fcmToken`
  - Sessão local do app da criança fixa o contexto do perfil pareado
- **Revogação:** responsável pode revogar dispositivo; app da criança deve perder acesso (validar em leituras/regras e no bootstrap da sessão).

### 5.3 Contatos e convites
- **Identidade na rede:** definir um identificador compartilhável (código/QR do perfil ou da família) mapeado em índice controlado (ex.: `usersIndex/{profileKey}`) sem expor dados sensíveis.
- **Convite:** criar `invitations/{inviteId}` (status `pending`, expiração).
- **Aprovação:** responsável aceita/recusa; ao aceitar, criar/atualizar `contacts/{guardianUid}/approved/{contactId}` para ambos os lados conforme política.
- **Regra:** criança só pode iniciar/listar conversas com contatos aprovados para seu escopo.

### 5.4 Conversas e mensagens 1:1
- **Conversa direta:** `conversations/{conversationId}` com `type=direct`, membros e `guardianScopes`.
  - `conversationId` pode ser determinístico para o par (ex.: hash ordenado dos `memberProfileKeys`) para evitar duplicatas.
- **Envio de texto:** criar doc em `conversations/{cid}/messages/{mid}` com `type=text`, `senderKey`, `sentAt` (server timestamp).
- **Envio de mídia (imagem/áudio):**
  1. Upload para Storage em `conversations/{cid}/{mid}/{filename}`
  2. Gravar mensagem com `type=image|audio` e metadados (`storagePath`, `mimeType`, `size`, `duration`)
- **Leitura em tempo real:** listener paginado (`orderBy sentAt desc`, `limit`) com paginação reversa na UI.
- **Recibos básicos:** atualizar status/`readAt` por membro (modelar para suportar evolução a grupos).

### 5.5 Notificações (FCM)
- Registrar `fcmToken` por dispositivo em `devices/{deviceId}` e atualizar em refresh.
- Cloud Function (trigger `onCreate` de mensagem): obter tokens dos destinatários da conversa (excluindo remetente/dispositivos revogados) e enviar push com payload mínimo (evitar conteúdo sensível na notificação quando necessário).
- Tratar abertura por notificação (deep link) para navegar à conversa.

## 6. Cloud Functions (Fase 1 — a implementar)

- **Atualizar `lastMessage`:** ao criar mensagem, atualizar `conversations/{cid}.lastMessage` e `updatedAt`.
- **Fanout de push:** enviar FCM para membros elegíveis.
- **Validações:** (opcional, recomendado) validar criação de convites/aceites e consistência de membership para reduzir lógica sensível no cliente.
- **Higiene:** limpar tokens inválidos ao receber erros do FCM.

## 7. Regras de segurança (endurecimento necessário)

Os arquivos em `firebase/rules/` são esqueletos. Para a Fase 1, endurecer para:
- Permitir escrita em `guardians/{uid}/**` apenas ao `auth.uid == uid`.
- Permitir que um dispositivo/perfil infantil leia/escreva apenas dados do seu `guardianUid` e conversas onde é membro autorizado.
- Restringir `conversations/{cid}/messages` a membros de `conversations/{cid}/members` (ou validação equivalente).
- Restringir convites/contatos aos envolvidos e ao responsável.
- Storage: leitura/gravação de mídia condicionada à participação na conversa.
- Considerar **App Check** para mitigar abuso de clientes não autorizados.

## 8. UX (telas mínimas Fase 1)

- Splash/bootstrap (resolve sessão: responsável ou perfil infantil pareado)
- Login/verificação do responsável
- Home do responsável: filhos, conversas, convites, configurações
- Criar/editar perfil infantil + gerar pareamento
- Tela de pareamento no dispositivo da criança (inserir código/ler QR)
- Lista de contatos aprovados e fluxo de convite/aprovação
- Lista de conversas e tela de chat 1:1 (texto, gravar áudio, enviar imagem)
- Configurações básicas: dispositivos, revogar acesso, preferências de notificação

## 9. Plano de execução incremental

1. Scaffold do Flutter + integração Firebase + roteamento/tema
2. Auth do responsável e documento `guardian`
3. Perfis infantis e pareamento/revogação de dispositivos
4. Modelo de convites/contatos aprovados
5. Chat 1:1 (texto) em tempo real
6. Mídia (imagem/áudio) com Storage
7. Recibos básicos e `lastMessage`
8. Push notifications (FCM + Functions)
9. Endurecimento de regras, testes em família (Play teste interno/TestFlight) e correções

## 10. Fora da Fase 1 (planejado adiante)

- Grupos, reações, reply/forward avançado, vídeo/documentos, localização (Fase 2)
- Chamadas voz/vídeo via WebRTC/TURN (Fase 3)
- Status/stories, backups, multi-dispositivo avançado (Fase 4)
- E2EE e hardening para lançamento público (Fase 5)
