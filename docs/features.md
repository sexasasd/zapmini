# Mapeamento de funcionalidades — ZapMini

Objetivo: orientar a evolução do ZapMini rumo a uma experiência completa de mensageria em **rede própria**. O app não se conecta à rede do WhatsApp; funcionalidades abaixo são equivalentes em experiência, implementadas na infraestrutura do ZapMini.

## 1. Identidade e acesso

| Funcionalidade | Descrição | Fase | Observações |
|---|---|---|---|
| Conta do responsável | Cadastro com número verificado (âncora de confiança) | 1 | Firebase Auth (Phone) |
| Perfis infantis | Perfis vinculados ao responsável, sem número próprio | 1 | Gerenciados pelo guardião |
| Pareamento de dispositivo | Autorizar aparelho da criança (QR/código/PIN) | 1 | Dispositivos podem ser revogados |
| Multi-dispositivo | Múltiplas sessões sincronizadas por perfil | 4-5 | Complexidade alta (estado/chaves) |

## 2. Contatos e relacionamento

| Funcionalidade | Descrição | Fase | Observações |
|---|---|---|---|
| Convites na rede | Convidar usuários do ZapMini (link/código/QR) | 1 | Sem integração com contatos do WhatsApp |
| Aprovação parental | Responsável aprova/bloqueia contatos | 1 | Requisito central de segurança |
| Bloqueio/silêncio | Bloquear contatos e silenciar conversas | 2-4 | Configurações por perfil/conversa |

## 3. Mensagens

| Funcionalidade | Descrição | Fase | Observações |
|---|---|---|---|
| Texto e emojis | Mensagens de texto, emojis | 1 | |
| Áudio (voz) | Gravação e envio de mensagens de voz | 1 | Storage + player |
| Imagens | Câmera/galeria, envio e visualização | 1 | Compressão/thumbnails recomendados |
| Vídeo e documentos | Envio de vídeos e arquivos | 2 | Limites de tamanho/custo |
| Localização/contato | Compartilhar localização e contato (rede própria) | 2 | Permissões de sistema |
| Recibos | Enviado/entregue/lido | 1-2 | Modelar recibos por membro em grupos |
| Responder/encaminhar | Reply e forward | 2 | |
| Reações | Reações a mensagens | 2 | |
| Edição/exclusão | Editar/apagar mensagens (conforme política) | 2-4 | Definir janelas e semântica |
| Busca | Busca em conversas/histórico | 2 | Indexação/estratégia de consulta |

## 4. Grupos

| Funcionalidade | Descrição | Fase | Observações |
|---|---|---|---|
| Criação e gestão | Criar grupos, nome/foto/descrição | 2 | |
| Administração | Admins, adicionar/remover membros | 2 | Regras parentais aplicáveis |
| Grupos avançados | Comunidades/subgrupos (se desejado) | 4+ | Escopo opcional |

## 5. Chamadas

| Funcionalidade | Descrição | Fase | Observações |
|---|---|---|---|
| Voz 1:1 | Chamadas de voz | 3 | WebRTC + sinalização + STUN/TURN |
| Vídeo 1:1 | Chamadas de vídeo | 3 | Mesma infraestrutura de mídia |
| Chamadas em grupo | Voz/vídeo com múltiplos participantes | 3-4 | Custo/complexidade elevados (SFU pode ser necessário) |
| Histórico de chamadas | Registro e estados (perdida, etc.) | 3 | |

## 6. Status e presença

| Funcionalidade | Descrição | Fase | Observações |
|---|---|---|---|
| Presença | Online/última atividade, digitando | 3 | Controles de privacidade |
| Status/Stories | Publicações temporárias (texto/mídia) | 4 | Audiência e expiração |

## 7. Segurança, privacidade e operação

| Funcionalidade | Descrição | Fase | Observações |
|---|---|---|---|
| Controles parentais | Aprovação, limites/horários, revogação | 1-4 | Evoluir gradualmente |
| Notificações | Push configurável | 1-2 | FCM + preferências |
| Backups | Backup/restauração de histórico e mídia | 4-5 | Considerar implicações de privacidade/E2EE |
| Proteção e moderação | App Check, anti-abuso, denúncias | 2-5 | Essencial para lançamento público |
| E2EE | Criptografia de ponta a ponta | 5 | Projeto dedicado (chaves, multi-dispositivo, backups) |

## Dependências críticas

- **Infra de chamadas:** provedores/servidores TURN e qualidade de rede são fatores de custo e confiabilidade.
- **Custos Firebase:** leituras/escritas em tempo real, armazenamento/egress de mídia e execução de Functions devem ser monitorados.
- **Compliance:** requisitos legais para apps voltados a crianças/famílias devem ser atendidos antes de lançamento público.
