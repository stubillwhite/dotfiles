"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.VSCodeKeyLinux = void 0;
class VSCodeKeyLinux {
    constructor(first, second) {
        this.os = "Linux";
        this.keys = [];
        this.keys.push(this.convert(first));
        if (second) {
            this.keys.push(this.convert(second));
        }
    }
    convert(intelliJ) {
        return intelliJ.keystroke.replace(/ /gi, "+");
    }
}
exports.VSCodeKeyLinux = VSCodeKeyLinux;
//# sourceMappingURL=VSCodeKeyLinux%20copy.js.map