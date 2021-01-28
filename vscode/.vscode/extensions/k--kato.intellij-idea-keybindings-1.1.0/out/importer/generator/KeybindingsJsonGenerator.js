"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.KeybindingsJsonGenerator = void 0;
class KeybindingsJsonGenerator {
    static async gene(keybindings) {
        return JSON.stringify(keybindings, undefined, 4);
    }
}
exports.KeybindingsJsonGenerator = KeybindingsJsonGenerator;
//# sourceMappingURL=KeybindingsJsonGenerator.js.map