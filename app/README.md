# App Flutter (ZapMini)

Este diretório é destinado ao aplicativo Flutter do ZapMini.

## Gerar o projeto (quando o Flutter estiver instalado)

No diretório raiz do repositório (`zapmini/`):

```bash
flutter create --org com.zapmini --project-name zapmini_app app
cd app
flutter pub get
```

> Se a pasta `app/` já existir com arquivos, gere em um diretório temporário e mescle, ou remova/renomeie conforme necessário. Ajuste `--org` para o identificador final antes da publicação.

## Configurar Firebase

```bash
dart pub global activate flutterfire_cli
flutterfire configure --project <SEU_PROJECT_ID>
```

Adicione as dependências conforme `docs/phase1-implementation.md` e `docs/setup.md`.

## Estrutura sugerida (`lib/`)

Consulte `../docs/phase1-implementation.md` para a arquitetura de pastas, módulos e fluxos da Fase 1:

- `core/` — tema, constantes, utilidades, roteamento
- `features/auth_guardian/` — onboarding/login do responsável
- `features/family/` — perfis infantis e pareamento de dispositivos
- `features/contacts/` — convites e aprovação de contatos
- `features/chat/` — conversas e mensagens 1:1
- `features/settings/` — controles básicos do responsável
- `shared/` — modelos, repositórios, serviços Firebase
