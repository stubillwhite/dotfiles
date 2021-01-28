"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.KeystrokeKeyMapping = void 0;
class KeystrokeKeyMapping {
    constructor(intellij, vscode) {
        this.intellij = new RegExp(`\\b${intellij}\\b`, 'g'); // whole words only
        this.vscode = vscode;
    }
}
exports.KeystrokeKeyMapping = KeystrokeKeyMapping;
//# sourceMappingURL=KeystrokeKeyMapping.js.map