"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.VSCodeKeyMac = void 0;
class VSCodeKeyMac {
    constructor(first, second) {
        this.key = this.convert(first);
        if (second) {
            this.key += " " + this.convert(second);
        }
    }
    convert(intelliJ) {
        return intelliJ.keystroke
            .replace(/ /gi, "+")
            .replace(/meta/gi, "cmd");
    }
}
exports.VSCodeKeyMac = VSCodeKeyMac;
//# sourceMappingURL=VSCodeKeyMac%20copy.js.map