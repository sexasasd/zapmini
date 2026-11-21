/**
 * ZapMini - Cloud Functions (esqueleto)
 *
 * Responsabilidades típicas (a implementar por fases):
 * - Gatilhos de notificação (nova mensagem, convite, chamada)
 * - Validações server-side e manutenção de invariantes (ex.: lastMessage)
 * - Gerenciamento de convites/pareamento e revogação de dispositivos
 * - Sinalização auxiliar para chamadas (se não usar apenas cliente/Firestore)
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// Exemplo: callable para health check
exports.health = functions.https.onCall(async (_data, _context) => {
  return { ok: true, service: "zapmini-functions", ts: Date.now() };
});

// TODO (Fase 1): onCreate em conversations/{cid}/messages/{mid}
//  - atualizar lastMessage na conversa
//  - enviar FCM aos membros (respeitando preferências/silêncio)

// TODO (Fase 1): callable/trigger para convites e aprovação de contatos

// TODO (Fase 3): suporte a sinalização de chamadas (offer/answer/ICE) e notificações de toque
