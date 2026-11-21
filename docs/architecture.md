# Arquitetura — ZapMini

## 1. Visão geral

ZapMini é um sistema de mensagens em **rede própria** composto por:

- **App cliente (Flutter, Android/iOS):** UI, experiência de chat, captura de mídia, gerenciamento de sessão/perfis e integração com serviços Firebase.
- **Firebase (BaaS):** autenticação, banco de dados em tempo real (Firestore), armazenamento de mídia (Storage), notificações (FCM) e lógica server-side (Cloud Functions).
- **Serviços auxiliares (fases futuras):** infraestrutura de chamadas (sinalização + STUN/TURN para WebRTC), processamento de mídia, moderação e observabilidade.

```
[App Responsável/Filho] <-> [Firebase Auth]
         |                 [Firestore (dados/tempo real)]
         |                 [Storage (mídia)]
         |                 [FCM (push)]
         |                 [Cloud Functions (regras de negócio/gatilhos)]
         |
         +-(fase chamadas)-> [Sinalização] <-> [STUN/TURN/WebRTC peers]
```

## 2. Princípios

- **Segurança e controle parental por padrão:** acesso a conversas/contatos condicionado a vínculo familiar e aprovações.
- **Identidade sem número para crianças:** perfis infantis vinculados à conta do responsável, com autenticação/pareamento de dispositivo controlado.
- **Entrega incremental:** base sólida de mensagens antes de recursos de alta complexidade (chamadas, E2EE completa, multi-dispositivo avançado).
- **Conformidade e privacidade:** minimização de dados, consentimento, trilhas de auditoria para ações parentais quando necessário.

## 3. Componentes

### 3.1 App Flutter
- **Camadas sugeridas:** apresentação (UI/widgets), estado (Riverpod/Bloc), domínio (casos de uso), dados (repositórios/serviços Firebase).
- **Módulos funcionais:** onboarding do responsável, gestão familiar, contatos/convites, chat 1:1, grupos, mídia, notificações, (futuro) chamadas e status.
- **Gerenciamento de sessão:** sessão do responsável (autenticada) e sessão do perfil infantil (token/dispositivo autorizado vinculado ao guardião).

### 3.2 Autenticação e identidade
- **Responsável:** verificação por número de telefone (Firebase Auth Phone) como âncora de confiança.
- **Criança:** perfil sem telefone (`childId`) sob `guardianId`; acesso ao app via pareamento autorizado (ex.: QR/código gerado pelo responsável, PIN do perfil, ou dispositivo registrado).
- **Autorização:** todas as operações sensíveis validadas por regras de segurança (Firestore/Storage) e, quando necessário, por Cloud Functions.

### 3.3 Dados e tempo real (Firestore)
- Coleções para usuários/guardiões, perfis infantis, dispositivos autorizados, contatos/relações, conversas, mensagens, grupos, convites e (futuro) status/chamadas.
- Atualizações em tempo real via listeners/snapshots para chat e presença.
- Paginação de mensagens e retenção/limites para controle de custo e desempenho.

### 3.4 Mídia (Storage)
- Upload/download de imagens, áudio, vídeo e documentos.
- Regras de acesso baseadas em participação na conversa e vínculo familiar.
- (Futuro) compressão/transcodificação e geração de thumbnails via Functions.

### 3.5 Notificações (FCM)
- Tokens por dispositivo; envio via Cloud Functions em eventos de nova mensagem/chamada/convite.
- Respeito a configurações de silêncio/horários definidos pelo responsável (quando aplicável).

### 3.6 Chamadas de voz/vídeo (fase futura)
- **Mídia:** WebRTC ponto a ponto quando possível.
- **Sinalização:** troca de ofertas/respostas/ICE via Firestore/RTDB ou serviço dedicado.
- **Conectividade:** servidores STUN/TURN (necessários para NATs restritos; TURN implica custo de infraestrutura).
- **Gerenciamento:** estados de chamada, toque, timeout, registro de chamadas.

## 4. Segurança (abordagem por fases)

- **Fase 1:** TLS em trânsito (Firebase), autenticação forte do responsável, regras rigorosas de acesso no Firestore/Storage, validação server-side de operações críticas, App Check.
- **Fase 2+:** auditoria de eventos, proteção contra abuso/spam, controles parentais avançados.
- **Fase posterior (paridade avançada):** criptografia de ponta a ponta (E2EE) para mensagens/chamadas (ex.: protocolo no estilo Signal) — requer projeto cuidadoso de gerenciamento de chaves, multi-dispositivo e backups.

> Nota: "todas as funções do WhatsApp" inclui E2EE robusta e multi-dispositivo; isso é um objetivo de longo prazo e deve ser tratado como fase dedicada de segurança.

## 5. Observabilidade e operação

- Crash reporting e métricas de desempenho (ex.: Crashlytics/Performance Monitoring).
- Logs e alertas para funções críticas (envio de push, falhas de chamada/sinalização).
- Gestão de custos Firebase (leituras/escritas, storage, egress, Functions, TURN).

## 6. Riscos e limitações conhecidos

- **Chamadas WebRTC em escala:** exigem TURN e tuning de qualidade/rede; complexidade alta.
- **E2EE e backups:** impacto em busca, histórico multi-dispositivo e recuperação de conta.
- **Paridade total com mensageiros maduros:** envolve muitas funcionalidades e anos de evolução; priorização por fases é essencial para um lançamento confiável.
