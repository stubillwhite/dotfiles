"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.IntelliJSyntaxAnalyzer = void 0;
const VSCodeKeybindingDefault_1 = require("../model/vscode/implement/VSCodeKeybindingDefault");
const VSCodeKeyLinux_1 = require("../model/vscode/implement/VSCodeKeyLinux");
const VSCodeKeyMac_1 = require("../model/vscode/implement/VSCodeKeyMac");
const VSCodeKeyWindows_1 = require("../model/vscode/implement/VSCodeKeyWindows");
class IntelliJSyntaxAnalyzer {
    constructor(osDestination, intellijDefaults, intellijCustoms, vscodeDefaults, actionIdCommandMappings, keystrokeKeyMappings) {
        this.addCustomIntelliJ = (keybindings = [], vscodeDefault, intellijDefault, intellijCustom) => {
            const key = this.convertToKey(intellijCustom).key;
            const when = vscodeDefault.when;
            const command = vscodeDefault.command;
            const alreadyBinded = keybindings.some(keybinding => keybinding.key === key && keybinding.command === command);
            if (alreadyBinded) {
                return;
            }
            keybindings.push(new VSCodeKeybindingDefault_1.VSCodeKeybindingDefault(command, key, when));
        };
        this.addDefaultIntelliJ = (keybindings = [], vscodeDefault, intellijDefault) => {
            const key = this.convertToKey(intellijDefault).key;
            const when = vscodeDefault.when;
            const command = vscodeDefault.command;
            const alreadyBinded = keybindings.some(keybinding => keybinding.key === key && keybinding.command === command);
            if (alreadyBinded) {
                return;
            }
            keybindings.push(new VSCodeKeybindingDefault_1.VSCodeKeybindingDefault(command, key, when));
        };
        this.removeDefaultVSCode = (keybindings = [], vscodeDefault, intellijDefault, intellijCustom = undefined) => {
            const key = vscodeDefault.key;
            const command = vscodeDefault.command;
            const alreadyBinded = keybindings.some(keybinding => keybinding.key === key && keybinding.command.endsWith(command));
            if (alreadyBinded) {
                return;
            }
            const removedCommand = `${IntelliJSyntaxAnalyzer.REMOVE_KEYBINDING}${command}`;
            keybindings.push(new VSCodeKeybindingDefault_1.VSCodeKeybindingDefault(removedCommand, key));
        };
        this.removeDefaultIntelliJ = (keybindings = [], vscodeDefault, intellijDefault, intellijCustom = undefined) => {
            const key = this.convertToKey(intellijDefault).key;
            const command = vscodeDefault.command;
            const alreadyBinded = keybindings.some(keybinding => keybinding.key === key && keybinding.command.endsWith(command));
            if (alreadyBinded) {
                return;
            }
            const removedCommand = `${IntelliJSyntaxAnalyzer.REMOVE_KEYBINDING}${command}`;
            keybindings.push(new VSCodeKeybindingDefault_1.VSCodeKeybindingDefault(removedCommand, key));
        };
        this.osDestination = osDestination;
        this.intellijDefaults = intellijDefaults;
        this.intellijCustoms = IntelliJSyntaxAnalyzer.groupBy(intellijCustoms, x => x.actionId);
        this.vscodeDefaults = IntelliJSyntaxAnalyzer.groupBy(vscodeDefaults, x => x.command);
        this.actionIdCommandMappings = IntelliJSyntaxAnalyzer.groupBy(actionIdCommandMappings, x => x.intellij);
        this.keystrokeKeyMappings = keystrokeKeyMappings;
    }
    // FIXME: high-cost
    async convert() {
        const keybindings = [];
        // set custom
        this.action(keybindings, this.addCustomIntelliJ);
        // set default
        this.action(keybindings, undefined, this.addDefaultIntelliJ);
        // remove default
        this.action(keybindings, this.removeDefaultVSCode, this.removeDefaultVSCode);
        // remove default
        this.action(keybindings, this.removeDefaultIntelliJ, this.removeDefaultIntelliJ);
        return keybindings;
    }
    action(keybindings = [], onCustom, onDefault = undefined) {
        // FIXEME: This loop is not correct because it duplicates when there are two defaults. Rewrite when I have time
        this.intellijDefaults.forEach(intellijDefault => {
            if (this.actionIdCommandMappings[intellijDefault.actionId]) {
                this.actionIdCommandMappings[intellijDefault.actionId].forEach(actionIdCommandMapping => {
                    if (this.vscodeDefaults[actionIdCommandMapping.vscode]) {
                        this.vscodeDefaults[actionIdCommandMapping.vscode].forEach(vscodeDefault => {
                            if (this.intellijCustoms[actionIdCommandMapping.intellij]) {
                                if (onCustom) {
                                    this.intellijCustoms[actionIdCommandMapping.intellij].forEach(intellijCustom => {
                                        onCustom(keybindings, vscodeDefault, intellijDefault, intellijCustom);
                                    });
                                }
                            }
                            else {
                                if (onDefault) {
                                    onDefault(keybindings, vscodeDefault, intellijDefault, undefined);
                                }
                            }
                        });
                    }
                });
            }
        });
    }
    convertToKey(intellijKeymap) {
        switch (this.osDestination) {
            case 'Linux':
                return new VSCodeKeyLinux_1.VSCodeKeyLinux(intellijKeymap, this.keystrokeKeyMappings);
            case 'Mac':
                return new VSCodeKeyMac_1.VSCodeKeyMac(intellijKeymap, this.keystrokeKeyMappings);
            case 'Windows':
                return new VSCodeKeyWindows_1.VSCodeKeyWindows(intellijKeymap, this.keystrokeKeyMappings);
        }
    }
    static groupBy(array, prop) {
        return array.reduce((groups, item) => {
            var _a;
            const val = prop(item);
            groups[val] = (_a = groups[val]) !== null && _a !== void 0 ? _a : [];
            groups[val].push(item);
            return groups;
        }, {});
    }
}
exports.IntelliJSyntaxAnalyzer = IntelliJSyntaxAnalyzer;
IntelliJSyntaxAnalyzer.REMOVE_KEYBINDING = '-';
//# sourceMappingURL=IntelliJSyntaxAnalyzer.js.map