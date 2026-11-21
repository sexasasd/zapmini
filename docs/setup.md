# Setup do ambiente — ZapMini

## 1. Pré-requisitos

### Ferramentas locais
- **Flutter SDK** (canal stable) + Dart
- **Android Studio** (SDK/Android toolchain) e/ou **Xcode** (para iOS, em macOS)
- **Node.js** (LTS) e **npm** (para Firebase CLI e Cloud Functions)
- **Firebase CLI**: `npm install -g firebase-tools`
- **Conta Google/Firebase** com projeto criado

### Verificação
```bash
flutter --version
flutter doctor
node --version
npm --version
firebase --version
```

> No ambiente onde esta base foi gerada, `node` estava disponível, mas `flutter` e `firebase` não estavam instalados.

## 2. Criar o projeto Firebase

1. Acesse o [Firebase Console](https://console.firebase.google.com/) e crie um projeto (ex.: `zapmini`).
2. Ative os produtos:
   - **Authentication**: provedor de telefone (para o responsável) e/ou e-mail/senha conforme estratégia; considerar login vinculado ao dispositivo para perfis infantis.
   - **Cloud Firestore** (ou Realtime Database; recomendado Firestore para consultas e modelagem).
   - **Cloud Storage** (mídia: áudio, imagens, vídeos, documentos).
   - **Cloud Messaging (FCM)** (notificações push).
   - **Cloud Functions** (lógica de servidor: convites, validações, gatilhos de notificação, sinalização auxiliar).
   - (Opcional/futuro) **Remote Config**, **Crashlytics**, **App Check**.
3. Registre os apps Android e iOS no projeto Firebase e baixe os arquivos de configuração:
   - Android: `google-services.json`
   - iOS: `GoogleService-Info.plist`

## 3. Criar o app Flutter

No diretório raiz do repositório:

```bash
flutter create --org com.zapmini --project-name zapmini_app app
cd app
flutter pub get
```

> Ajuste `--org` para o identificador da sua organização antes de publicação.

### Dependências sugeridas (a avaliar/ajustar)
- Firebase: `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `firebase_messaging`, `cloud_functions`
- Estado/arquitetura: `flutter_riverpod` ou `bloc`
- Navegação: `go_router`
- Mídia: `image_picker`, `file_picker`, `record` (áudio), `cached_network_image`, `video_player`
- Chamadas (fase futura): `flutter_webrtc` + servidor de sinalização/TURN
- Utilidades: `uuid`, `intl`, `permission_handler`, `shared_preferences`/armazenamento seguro

Instale com `flutter pub add ...` conforme necessidade de cada fase.

## 4. Configurar FlutterFire

```bash
dart pub global activate flutterfire_cli
flutterfire configure --project <seu-projeto-firebase>
```

Isso gera `lib/firebase_options.dart` e vincula as plataformas.

## 5. Configurar Firebase localmente (rules/functions)

Na pasta `firebase/` deste repositório:

```bash
cd firebase
firebase login
firebase init
```

Selecione: Firestore, Storage, Functions (e Emulators para desenvolvimento local). Aponte para os arquivos em `firebase/rules/` e `firebase/functions/` conforme estrutura adotada.

### Emuladores (recomendado para desenvolvimento)
```bash
firebase emulators:start
```

## 6. Assinatura e publicação (visão geral)

### Android
- Gerar keystore de upload/release
- Configurar `android/key.properties` e signing em `build.gradle`
- Criar conta no Google Play Console, ficha da loja, política de privacidade, classificação de conteúdo

### iOS
- Conta Apple Developer, certificados e provisioning profiles
- Configurar no Xcode
- App Store Connect: ficha do app, privacidade, revisão

## 7. Teste com família (fase inicial)

- Distribuição Android: teste interno/fechado no Google Play ou APK assinado para testers
- Distribuição iOS: TestFlight
- Validar: cadastro do responsável, criação de perfis infantis, pareamento de dispositivos, convites/contatos aprovados, troca de mensagens e notificações

## 8. Considerações de compliance

- Publicar **Política de Privacidade** e **Termos de Uso** acessíveis no app e nas lojas
- Implementar **consentimento do responsável** para perfis de crianças
- Minimizar coleta de dados e definir retenção/exclusão
- Revisar requisitos legais aplicáveis (LGPD/ECA e, se aplicável, COPPA/GDPR-K) antes do lançamento público
