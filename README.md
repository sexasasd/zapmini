# ZapMini

ZapMini é um aplicativo de mensagens familiar em rede própria, inspirado na experiência de mensageiros modernos, com foco em permitir que crianças se comuniquem com segurança vinculadas à conta de um responsável (sem necessidade de número de telefone próprio).

> **Aviso importante:** ZapMini é um produto independente, com rede e infraestrutura próprias. Não é afiliado, integrado ou compatível com o WhatsApp/Meta, e não se conecta à rede do WhatsApp. Evite uso de marcas, logos ou ativos que infrinjam direitos de terceiros.

## Objetivos

- **Rede própria:** mensagens e chamadas trafegam pela infraestrutura do ZapMini.
- **Vínculo familiar:** o responsável cria a conta com seu número e gerencia perfis infantis sem número próprio.
- **Segurança e controle parental:** contatos aprovados, controles de uso e visibilidade configurável.
- **Evolução para paridade funcional:** entregar incrementalmente recursos equivalentes aos de mensageiros populares (chat, grupos, mídia, chamadas, status, etc.), conforme viabilidade técnica e de conformidade.

## Decisões iniciais

- **Stack:** Flutter + Firebase
- **Plataformas (lançamento inicial):** Android e iOS
- **Nome provisório:** ZapMini
- **Escopo desejado:** amplo (experiência tipo mensageiro completo), entregue em fases

## Status do projeto

Este repositório contém a base de planejamento e a estrutura inicial para implementação:

- `docs/` — arquitetura, modelo de dados, roadmap e setup
- `firebase/` — esqueleto de regras e Cloud Functions

> **Pré-requisito:** o Flutter SDK não foi detectado neste ambiente no momento da criação desta base. Consulte `docs/setup.md` para preparar o ambiente e gerar o app Flutter.

## Estratégia de entrega (resumo)

Dado o escopo amplo (incluindo chamadas de voz/vídeo e recursos avançados), o desenvolvimento será faseado:

1. **Fundação (MVP testável em família):** autenticação do responsável, perfis infantis, contatos aprovados, chat 1:1 (texto/áudio/imagem), notificações.
2. **Grupos e colaboração:** grupos, administração, mídia/arquivos avançados, localização/contatos compartilhados.
3. **Chamadas e presença:** chamadas de voz/vídeo (WebRTC), indicadores de presença, melhorias de tempo real.
4. **Status e paridade avançada:** status/stories, reações/encaminhamento avançado, backups, multi-dispositivo, hardening de segurança (incl. E2EE).

Detalhes em `docs/roadmap.md`.

## Como começar

1. Leia `docs/setup.md` para instalar ferramentas e configurar o Firebase.
2. Revise `docs/architecture.md` e `docs/data-model.md`.
3. Crie o projeto Flutter (`flutter create`) e integre com Firebase conforme o guia.
4. Implemente as fases descritas em `docs/roadmap.md`.

## Licença e conformidade

- Definir licença do projeto antes da publicação.
- Antes de lançamento público: publicar Política de Privacidade e Termos de Uso, implementar consentimento parental e revisar conformidade aplicável (ex.: LGPD/ECA no Brasil; COPPA/GDPR-K quando aplicável).
