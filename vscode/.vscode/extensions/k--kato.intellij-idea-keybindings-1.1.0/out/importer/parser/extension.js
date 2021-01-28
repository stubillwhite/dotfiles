"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.activate = void 0;
const parser = require("fast-xml-parser");
const vscode = require("vscode");
const OS_1 = require("./importer/model/OS");
function activate(context) {
    vscode.commands.registerCommand('IntelliJ/importFile', async function () {
        /*---------------------------------------------------------------------
         * Reader
         *-------------------------------------------------------------------*/
        const osOptions = {
            placeHolder: 'Which OS do you want to convert for?',
            ignoreFocusOut: true,
        };
        const osDestination = (await vscode.window.showQuickPick(OS_1.OSArray.map(os => os), osOptions));
        if (!osDestination) {
            return;
        }
        const readerXmlOptions = {
            canSelectFiles: true,
            filters: {
                XML: ['xml'],
            },
        };
        // Custom file
        const readerCustomXmlUri = await vscode.window.showOpenDialog(readerXmlOptions);
        if (!readerCustomXmlUri || !readerCustomXmlUri[0]) {
            return;
        }
        const readCustomXmlData = await vscode.workspace.fs.readFile(readerCustomXmlUri[0]);
        const readCustomXml = Buffer.from(readCustomXmlData).toString('utf8');
        // // Default file
        // const readerDefaultXmlUri = vscode.Uri.file(
        //     context.asAbsolutePath(posix.join('resource', 'default', osDestination, 'IntelliJ.xml'))
        // );
        // const readDefaultXmlData = await vscode.workspace.fs.readFile(readerDefaultXmlUri);
        // const readDefaultXmlStr = Buffer.from(readDefaultXmlData).toString('utf8');
        // const readerDefaultVSCodeJsonUri = vscode.Uri.file(
        //     context.asAbsolutePath(posix.join('resource', 'default', osDestination, 'VSCode.json'))
        // );
        // const readDefaultVSCodeJsonData = await vscode.workspace.fs.readFile(readerDefaultVSCodeJsonUri);
        // const readDefaultVSCodeJsonStr = Buffer.from(readDefaultVSCodeJsonData).toString('utf8');
        // const readDefaultVSCodeJson = JSON.parse(readDefaultVSCodeJsonStr);
        /*---------------------------------------------------------------------
         * Parser
         *-------------------------------------------------------------------*/
        const parserXmlOptions = {
            ignoreAttributes: false,
            parseAttributeValue: true,
            arrayMode: true,
        };
        if (!parser.validate(readCustomXml)) {
            vscode.window.showErrorMessage('Cannot load this IntelliJ IDEA Keymap file. Plesase check the file format.');
            return;
        }
        const parsedIntellijKeymapsJson = parser.parse(readCustomXml, parserXmlOptions);
        /*---------------------------------------------------------------------
         * Semantic Analyzer
         *-------------------------------------------------------------------*/
        // if (!parsedIntellijKeymapsJson?.keymap) {
        //     vscode.window.showErrorMessage(
        //         'Cannot find any IntelliJ IDEA Keymap settings in this file. Make sure that the file is an XML file exported from IntelliJ Idea.'
        //     );
        //     await vscode.window.showTextDocument(readerCustomXmlUri[0]);
        //     return;
        // }
        // const vscodeKeybindings = new Array<VSCodeKeybinding>();
        // const actionElements = parsedIntellijKeymapsJson.keymap[0].action;
        // for (const actionIndex in actionElements) {
        //     const actionIdAttr = actionElements[actionIndex]['@_id'];
        //     const keystorkeElements = actionElements[actionIndex]['keyboard-shortcut'];
        //     for (const keystrokeIndex in keystorkeElements) {
        //         const keyboardShortcutElement = keystorkeElements[keystrokeIndex];
        //         const firstKeystrokeAttr = keyboardShortcutElement['@_first-keystroke'];
        //         const secondKeystrokeAttr = keyboardShortcutElement['@_second-keystroke'];
        //         const intellijKeymapCustom = new IntelliJKeymapXML(
        //             actionIdAttr,
        //             osFrom,
        //             firstKeystrokeAttr,
        //             secondKeystrokeAttr
        //         );
        //         const vscodes = IntelliJSyntaxAnalyzer.convertToVSCode(osTo, intellijKeymapCustom);
        //         if (vscodes === IntelliJSyntaxAnalyzer.NO_MAPPING) {
        //             continue;
        //         }
        //         vscodes.forEach(vscode => vscodeKeybindings.push(vscode));
        //     }
        //     {
        //         const intellijKeymapCustom = new IntelliJKeymapXML(actionIdAttr, osFrom);
        //         const removeVcodes = IntelliJSyntaxAnalyzer.removeDefault(osTo, intellijKeymapCustom);
        //         if (removeVcodes === IntelliJSyntaxAnalyzer.NO_MAPPING) {
        //             continue;
        //         }
        //         removeVcodes.forEach(remove => {
        //             const duplicated = vscodeKeybindings.some(
        //                 // FIXME: high costs
        //                 add => add.command === remove.command && remove.key.endsWith(add.key)
        //             );
        //             if (!duplicated) {
        //                 vscodeKeybindings.push(remove);
        //             }
        //         });
        //     }
        // }
        /*---------------------------------------------------------------------
         * Code Generator
         *-------------------------------------------------------------------*/
        // const generatedVSCodeKeybindingsJson = JSON.stringify(vscodeKeybindings, undefined, 4);
        /*---------------------------------------------------------------------
         * Writer
         *-------------------------------------------------------------------*/
        const defaultWriteUri = context.storageUri;
        const writerOptions = {
            defaultUri: defaultWriteUri,
            filters: {
                JSON: ['json'],
            },
        };
        const writerUri = await vscode.window.showSaveDialog(writerOptions);
        if (!writerUri) {
            return;
        }
        // const writeData = Buffer.from(generatedVSCodeKeybindingsJson, 'utf8');
        // await vscode.workspace.fs.writeFile(writerUri, writeData);
        await vscode.window.showTextDocument(writerUri);
    });
}
exports.activate = activate;
//# sourceMappingURL=extension.js.map