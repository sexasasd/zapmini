# Roadmap — ZapMini

Roadmap faseado para construir um mensageiro profissional em rede própria, com teste inicial em família e evolução rumo à paridade de funcionalidades de mensageiros completos.

## Princípios de planejamento

- Entregar valor testável a cada fase (começando pelo uso familiar).
- Priorizar segurança, controle parental e estabilidade antes de escalar base de usuários.
- Tratar chamadas, E2EE completa e multi-dispositivo avançado como trilhas de alta complexidade.

## Fase 0 — Preparação (base do projeto)
**Objetivo:** ambiente pronto e fundações técnicas.
- Configurar repositório, convenções, CI básico (lint/test/build).
- Criar projeto Firebase, apps Android/iOS, FlutterFire, emuladores.
- Definir identidade visual inicial, nome/ícone, política de privacidade/termos (rascunho).
- Implementar esqueleto do app (navegação, tema, injeção de dependências/estado).

**Saída:** app "hello world" autenticando com Firebase e rodando em dispositivos de teste.

## Fase 1 — Fundação familiar (MVP testável)
**Objetivo:** uso real entre família em rede própria.
- **Conta do responsável:** onboarding e verificação por telefone.
- **Perfis infantis:** criação/edição/remoção sem número próprio.
- **Pareamento de dispositivo:** autorizar dispositivo da criança para um perfil (QR/código/PIN).
- **Contatos e convites:** convite dentro da rede, aprovação/bloqueio pelo responsável.
- **Chat 1:1:** texto, emojis, áudio gravado, imagens (câmera/galeria), recibos básicos (enviado/entregue/lido).
- **Notificações push:** novas mensagens e convites.
- **Controles básicos:** lista de contatos permitidos e gestão central pelo responsável.

**Saída:** família consegue conversar com segurança no ZapMini.

## Fase 2 — Grupos e compartilhamento avançado
**Objetivo:** comunicação em grupo e richer messaging.
- **Grupos:** criação, membros, admins, nome/foto/descrição.
- **Mensagens avançadas:** resposta, encaminhamento, reações, menções (se aplicável).
- **Mídia e arquivos:** vídeo, documentos, compressão/thumbnails, visualização in-app.
- **Compartilhamento:** localização e compartilhamento de contato (dentro da rede), notas de voz aprimoradas.
- **Busca e histórico:** busca em conversas, paginação e desempenho.

**Saída:** experiência de chat próxima de mensageiros completos (sem chamadas/status).

## Fase 3 — Chamadas e presença
**Objetivo:** comunicação síncrona em tempo real.
- **Infra de chamadas:** sinalização, integração WebRTC, servidores STUN/TURN.
- **Chamadas de voz 1:1** e depois **vídeo 1:1** (toque, aceitar/recusar, reconexão básica).
- **Chamadas em grupo** (escopo e limites definidos conforme custo/complexidade).
- **Presença e indicadores:** online/última atividade (com controles de privacidade), "digitando", gravação de áudio.
- **Qualidade:** métricas, fallback e tratamento de redes instáveis.

**Saída:** chamadas de voz/vídeo utilizáveis para o grupo familiar.

## Fase 4 — Status e recursos de paridade
**Objetivo:** ampliar paridade de funcionalidades.
- **Status/Stories:** publicação de texto/imagem/vídeo com expiração e controle de audiência.
- **Configurações e privacidade:** bloqueios, silenciamento, personalizações de notificação, armazenamento de dados.
- **Multi-dispositivo (básico a avançado):** sessões vinculadas e sincronização consistente.
- **Backups/restauração:** estratégia de backup do histórico e mídia (considerando implicações de segurança).

**Saída:** conjunto de recursos próximo ao esperado em um mensageiro maduro.

## Fase 5 — Segurança avançada, escala e lançamento público
**Objetivo:** prontidão para publicação ampla.
- **Hardening:** App Check, rate limiting, proteção anti-abuso, auditorias de regras.
- **E2EE (criptografia de ponta a ponta):** projeto e implementação para mensagens (e, se viável, chamadas), incluindo gestão de chaves e recuperação.
- **Compliance e lojas:** políticas finais, consentimento parental, classificação etária, materiais de loja, revisão Play/App Store.
- **Operação:** monitoramento, suporte, gestão de custos e escalabilidade.

**Saída:** app pronto para disponibilização pública com base de segurança e operação adequada.

## Mapeamento de funcionalidades (alto nível)

| Área | Exemplos | Fase alvo |
|---|---|---|
| Identidade familiar | Responsável, perfis infantis, pareamento | 1 |
| Contatos | Convites, aprovação, bloqueio | 1-2 |
| Mensagens | Texto, áudio, imagem, recibos | 1 |
| Grupos | Criação/admin/membros | 2 |
| Mídia/arquivos | Vídeo, docs, localização, contato | 2 |
| Chamadas | Voz/vídeo 1:1 e grupo, WebRTC/TURN | 3 |
| Status | Stories com audiência/expiração | 4 |
| Privacidade/segurança | Controles, backups, multi-dispositivo, E2EE | 4-5 |

> Estimativas de prazo dependem de equipe, infraestrutura (especialmente TURN para chamadas) e requisitos de compliance; recomenda-se validar cada fase com testes em família antes de avançar.
