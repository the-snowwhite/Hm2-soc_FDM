/****************************************************************************
**
** Copyright (C) 2014 Alexander Rössler
** License: LGPL version 2.1
**
** This file is part of QtQuickVcp.
**
** All rights reserved. This program and the accompanying materials
** are made available under the terms of the GNU Lesser General Public License
** (LGPL) version 2.1 which accompanies this distribution, and is available at
** http://www.gnu.org/licenses/lgpl-2.1.html
**
** This library is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
** Lesser General Public License for more details.
**
** Contributors:
** Alexander Rössler @ The Cool Tool GmbH <mail DOT aroessler AT gmail DOT com>
**
****************************************************************************/
//import QtQuick 2.0
import QtQuick 2.7
//import QtQuick.Controls 2.4
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import Machinekit.Controls 1.0
import Machinekit.Application 1.0
import Machinekit.HalRemote.Controls 1.0
import Machinekit.HalRemote 1.0
import Machinekit.Service 1.0
import Machinekit.Application.Controls 1.0
import Qt.labs.settings 1.0
//import Theme 1.0
import "./Controls"
import "./Controls.2"
import "./ManualTab"
import "./StatusBar"

//HalApplicationWindow {


ServiceWindow {
    id: root

    property bool wasConnected: false
//    property string labelName: "SG"
    property double gaugeZ0BorderValue: 50.0
//     property double spinMinimumValue: minTemperaturePin.value
//     property double spinMaximumValue: maxTemperaturePin.value
//    property double spinMinimumValue: -64
//    property double spinMaximumValue: 63
//    property double gaugeMinimumValue: spinMinimumValue
//    property double gaugeMaximumValue: spinMaximumValue * 1.1
    property double gaugeMinimumValue: -512
    property double gaugeMaximumValue: 512
    property double gaugeZ1BorderValue: gaugeMaximumValue * 0.9
//    property bool lastIntpolValue
//    property bool lastDedgeValue
    property double lastMresValue
    property double lastTblValue
    property double lastHendValue
    property double lastHstrtValue
    property double lastToffValue
    property double lastSgtValue
     property double defMresValue: mresSetSpin.value
//     property double defTblValue: tblSetSpin.value
//     property double defHendValue: hendSetSpin.value
//     property double defHstrtValue: hstrtSetSpin.value
//     property double defToffValue: toffSetSpin.value
//     property double defSgtValue: sgtSetSpin.value

    property int drvctrlReg:  drvctrlRegPin.value
    property int chopconfReg: chopconfRegPin.value
    property int smartenReg:  smartenRegPin.value
    property int sgcsconfReg: sgcsconfRegPin.value
    property int drvconfReg:  drvconfRegPin.value
//    property int fullreadresponseVal:  fullreadresponsePin.value
    property string regValues: "DRVCTRL; \t  0x" + drvctrlReg.toString(16).toUpperCase() + "\n" +
                               "CHOPCONF;\t  0x" + chopconfReg.toString(16).toUpperCase() + "\n" +
                               "SMARTEN;\t  0x" + smartenReg.toString(16).toUpperCase() + "\n" +
                               "SGCSCONF;\t  0x" + sgcsconfReg.toString(16).toUpperCase() + "\n" +
                               "DRVCONF;\t  0x" + drvconfReg.toString(16).toUpperCase()
    property string fullreadresponseValue_0: "Read Response 0: \t  0x" + fullreadresponsePin_0.value.toString(16).toUpperCase()
    property string fullreadresponseValue_1: "Read Response 1: \t  0x" + fullreadresponsePin_1.value.toString(16).toUpperCase()
    property string fullreadresponseValue_2: "Read Response 2: \t  0x" + fullreadresponsePin_2.value.toString(16).toUpperCase()
// + string( " %1" ).arg( 15, 1, 16 ).toUpper()
//    name: "TrinamicSPI"
//    title: qsTr("Trinamic SPI Test")
    property int themeBaseSize: 10
    property string lightgrayColour: "light gray"
    property string darkgrayColour: "gray"
    property string themeLight: "yellow"
    property string themeKnob: "white"
    property string themeLightGray: "light gray"
    property string themeGray: "gray"
    property string themeMainColor: "orange"
    property string themeMainColorDarker: "green"
    title: applicationCore.applicationName + (d.machineName === "" ? "" :" - " +  d.machineName)

    statusBar:applicationStatusBar
    toolBar: applicationToolBar
//    menuBar: applicationMenuBar



    ColumnLayout {
        id: window
        anchors.fill: parent
        anchors.margins: 10


        Loader {
                id: applicationToolBar
                source: "ApplicationToolBar.qml"
                active: true
        }

        Service {
            id: halrcompService
            type: "halrcomp"
        }

        Service {
            id: halrcmdService
            type: "halrcmd"
        }

        ApplicationCore {
            id: applicationCore
            notifications: applicationNotifications
            applicationName: "Trinamic-SPI"
        }


        visible: halRemoteComponent.ready || wasConnected
        enabled:  halRemoteComponent.connected

        HalRemoteComponent {
            id: halRemoteComponent
            halrcmdUri: halrcmdService.uri
            halrcompUri: halrcompService.uri
            ready: (halrcmdService.ready && halrcompService.ready) || connected
            name: "TrinamicSPI"
            containerItem: root
            create: false
            onErrorStringChanged: console.log(errorString)
            onConnectedChanged: root.wasConnected = true
        }

        Item {  // Hal Pins
            HalPin {
                id: drvctrlRegPin
                name: "drvctrl.reg"
                direction: HalPin.In
                type: HalPin.U32
            }

            HalPin {
                id: chopconfRegPin
                name: "chopconf.reg"
                direction: HalPin.In
                type: HalPin.U32
            }

            HalPin {
                id: smartenRegPin
                name: "smarten.reg"
                direction: HalPin.In
                type: HalPin.U32
            }

            HalPin {
                id: sgcsconfRegPin
                name: "sgcsconf.reg"
                direction: HalPin.In
                type: HalPin.U32
            }

            HalPin {
                id: drvconfRegPin
                name: "drvconf.reg"
                direction: HalPin.In
                type: HalPin.U32
            }

            HalPin {
                id: fullreadresponsePin_0
                name: "full.0.val"
                direction: HalPin.In
                type: HalPin.U32
            }

            HalPin {
                id: fullreadresponsePin_1
                name: "full.1.val"
                direction: HalPin.In
                type: HalPin.U32
            }

            HalPin {
                id: fullreadresponsePin_2
                name: "full.2.val"
                direction: HalPin.In
                type: HalPin.U32
            }

            HalPin {
                id: intpolSetPin
                name: "intpol.set"
                direction: HalPin.IO
                type: HalPin.Bit
            }

            HalPin {
                id: dedgeSetPin
                name: "dedge.set"
                direction: HalPin.IO
                type: HalPin.Bit
            }

            HalPin {
                id: chmSetPin
                name: "chm.set"
                direction: HalPin.IO
                type: HalPin.Bit
            }

            HalPin {
                id: rndtfSetPin
                name: "rndtf.set"
                direction: HalPin.IO
                type: HalPin.Bit
            }

            HalPin {
                id: hdec1SetPin
                name: "hdec1.set"
                direction: HalPin.IO
                type: HalPin.Bit
            }

            HalPin {
                id: hdec0SetPin
                name: "hdec0.set"
                direction: HalPin.IO
                type: HalPin.Bit
            }
        }

        RowLayout {
            ColumnLayout { // Status leds
                Layout.preferredWidth: 30
                Layout.alignment: Qt.AlignLeft
                ColumnLayout {
                    Label {
                        id: ststLabel
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.bold: true
                        text: "stst"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    HalLed {
                        id: ststLed
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        name: "stst.status"
                        onColor: "yellow"
                        Layout.preferredHeight: ststLabel.height * 0.9
                        Layout.preferredWidth: ststLabel.height * 0.9
                    }
                }

                ColumnLayout {
                    Label {
                        id: olbLabel
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.bold: true
                        text: "olb"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    HalLed {
                        id: olbLed
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        name: "olb.status"
                        onColor: "red"
                        Layout.preferredHeight: olbLabel.height * 0.9
                        Layout.preferredWidth: olbLabel.height * 0.9
                    }
                }

                ColumnLayout {
                    Label {
                        id: olaLabel
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.bold: true
                        text: "ola"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    HalLed {
                        id: olaLed
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        name: "ola.status"
                        onColor: "red"
                        Layout.preferredHeight: olaLabel.height * 0.9
                        Layout.preferredWidth: olaLabel.height * 0.9
                    }
                }

                ColumnLayout {
                    Label {
                        id: s2gbLabel
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.bold: true
                        text: "s2gb"
//                        color: "#21be2b"
                        horizontalAlignment: Text.AlignLeft
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    HalLed {
                        id: s2gbLed
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        name: "s2gb.status"
                        onColor: "red"
                        Layout.preferredHeight: s2gbLabel.height * 0.9
                        Layout.preferredWidth: s2gbLabel.height * 0.9
                    }
                }

                ColumnLayout {
                    Label {
                        id: s2gaLabel
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.bold: true
                        text:" s2ga"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    HalLed {
                        id: s2gaLed
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        name: "s2ga.status"
                        onColor: "red"
                        Layout.preferredHeight: s2gaLabel.height * 0.9
                        Layout.preferredWidth: s2gaLabel.height * 0.9
                    }
                }

                ColumnLayout {
                    Label {
                        id: otpwLabel
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.bold: true
                        text: "otpw"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    HalLed {
                        id: otpwLed
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        name: "otpw.status"
                        onColor: "red"
                        Layout.preferredHeight: otpwLabel.height * 0.9
                        Layout.preferredWidth: otpwLabel.height * 0.9
                    }
                }

                ColumnLayout {
                    Label {
                        id: otLabel
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.bold: true
                        text: "ot"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    HalLed {
                        id: otLed
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        name: "ot.status"
                        onColor: "red"
                        Layout.preferredHeight: otLabel.height * 0.9
                        Layout.preferredWidth: otLabel.height * 0.9
                    }
                }

                ColumnLayout {
                    Label {
                        id: sgLabel
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        font.bold: true
                        text: "sg"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    HalLed {
                        id: sgLed
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        name: "sg.status"
                        onColor: "red"
                        Layout.preferredHeight: sgLabel.height * 0.9
                        Layout.preferredWidth: sgLabel.height * 0.9
                    }
                }

                Item {
                    Layout.fillHeight: true
                }
            }

            ColumnLayout {  // Main window
                id: transport
                ApplicationStatusBar { id: applicationStatusBar }

                RowLayout {  // Velocity labels
                    Layout.fillWidth: true


                    Label {
                        text: qsTr("Axis")
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    AxisRadioGroup {
                        id: axisRadioGroup
                        Layout.fillWidth: false
                    }
                }

                RowLayout {  // Jog selection
                    Layout.fillWidth: true

                    JogButton {
                        id: decrementButton
                        Layout.fillWidth: false
                        direction: -1
                        distance: jogCombo.distance
                        axis: axisRadioGroup.axis
                        checkable: true
                    }

                    JogButton {
                        id: incrementButton
                        Layout.fillWidth: false
                        direction: 1
                        distance: jogCombo.distance
                        axis: axisRadioGroup.axis
                        checkable: true
                    }

                    JogDistanceComboBox {
                        id: jogCombo
                        Layout.fillWidth: true
                        axis: axisRadioGroup.axis
                    }

                    KeyboardJogControl {
                        id: keyboardJogControl
                        enabled: jogCombo.distance !== 0.0
                        onSelectAxis: axisRadioGroup.axis = axis
                        onIncrement: incrementButton._toggle(enabled)
                        onDecrement: decrementButton._toggle(enabled)
                        onSelectIncrement: {
                            if (jogCombo.currentIndex == 0) {
                                jogCombo.currentIndex = index;
                            }
                        }
                    }
                }

                RowLayout {  // Jog velocity labels
                    Layout.fillWidth: true
                    Layout.fillHeight: false

                    Label {
                        text: qsTr("Jog Velocity")
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Label {
                        text: (jogVelocitySlider.displayValue.toFixed(1) << mresSetSpin.value) + " " + "rev/min"
                    }
                }

                JogVelocitySlider { // Jog velocity slide
                    id: jogVelocitySlider
                    Layout.fillWidth: true
                    axis: axisRadioGroup.axis
                    proportional: false
                }

                HalGauge {
                    id: sgGauge
                    Layout.fillWidth: true
                    name: "sg.readout"
                    suffix: ""
                    decimals: 0
                    valueVisible: true
                    minimumValueVisible: false
                    maximumValueVisible: false
                    minimumValue: root.gaugeMinimumValue
                    maximumValue: root.gaugeMaximumValue
                    z0BorderValue: root.gaugeZ0BorderValue
                    z1BorderValue: root.gaugeZ1BorderValue
                    z0Color: valueVisible ? "green" : "white"
                    z1Color: valueVisible ? "yellow" : "white"
                    z2Color: valueVisible ? "red" : "white"

                    Label {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        text: qsTr("N/A")
                        visible: !sgGauge.valueVisible
                    }

                    MouseArea {
                        anchors.fill: parent
                        onDoubleClicked: control.visible = !control.visible
                        onClicked: sgChart.visible = !sgChart.visible
                        cursorShape: "PointingHandCursor"
                    }
                }

                RowLayout {  // Readout row
                    RowLayout {
                        id: readout
                        anchors.margins: 10
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Column {  // First Column (SPI Readout)
                            spacing: 10// Layout.fillWidth: true
                            Layout.alignment: Qt.AlignLeft
                            Text {  // Column header
                                text: "SPI registers\t Values:              "
                                color: "black"// color can be set on the entire element with this property

                            }

                            Rectangle { // Current register values
                                height: 120; width: parent.width
                                color: "white"//mouseArea2.pressed ? "black" : "gray"
                                Text {
                                    id: regTxt
                                    text: root.regValues


                                    color: "black"// color can be set on the entire element with this property

                                }
                            }

                            Rectangle {  // Read responses
                                height: 72; width: parent.width// color: mouseArea2.pressed ? "black" : "gray"
                                color: "light green"
                                Column {
                                    Text {
                                        id: readresponseTxt_0
                                        text: root.fullreadresponseValue_0
                                        color: "black"// color can be set on the entire element with this property
                                    }
                                    Text {
                                        id: readresponseTxt_1
                                        text: root.fullreadresponseValue_1
                                        color: "black"// color can be set on the entire element with this property
                                    }
                                    Text {
                                        id: readresponseTxt_2
                                        text: root.fullreadresponseValue_2
                                        color: "black"// color can be set on the entire element with this property
                                    }
                                }
                            }
                        }
                    }

                    LogChart {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        id: sgChart
                        Layout.fillHeight: true
                        visible: false
                        value: sgGauge.value
                        minimumValue: sgGauge.minimumValue
                        maximumValue: sgGauge.maximumValue
                        leftTextVisible: false
                        rightTextVisible: false
                        autoSampling: (sgGauge.halPin.synced) && visible
                        autoUpdate: autoSampling
                        updateInterval: 500
                        timeSpan: 120000
                        Layout.maximumHeight: 256
                        Layout.maximumWidth: 256
                        gridColor: qsTr("#eeeeee")
                        backgroundColor: qsTr("#ffffff")
                    }
                }

                RowLayout {  // Settings row
                    Column {  // First Column
                        spacing: 10// Layout.fillWidth: true
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Label {
                            font.bold: true
                            text: qsTr("Drvctrl:")
                        }

                        RowLayout {// set intpol values

                            id: intpolcontrol
                            visible: true

                            Label {
                                id: intpolLabel
//                                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                                font.bold: true
                                text:"Interpolation"
                            }

                            Switch2 {
                                id: intpolonOffSwitch
                                enabled: true
                                text: intpolSetPin.value  > 0 ? "x16" : "Disabled"
                                font.bold: true
                                onCheckedChanged: {
                                    if (checked) {
                                            intpolSetPin.value = 1
                                            intpolonOffSwitch.text = "x16"
                                    }
                                    else {
                                        intpolSetPin.value = 0
                                        intpolonOffSwitch.text = "Disabled"
                                    }
                                }

                                Binding {
                                    target: intpolonOffSwitch
                                    property: "checked"
                                    value: intpolSetPin.value  > 0
                                }
                            }
                        }

                        RowLayout {// set dedge values

                            id: dedgecontrol
                            visible: true
//                            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                            Label {
                                id: dedgeLabel
//                                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                                font.bold: true
                                text: "Step Edges"
                            }

                            Switch2 {
                                id: dedgeonOffSwitch
                                enabled: true
                                display: AbstractButton.TextBesideIcon
                                text: dedgeSetPin.value  > 0 ? "Double Edge" : "Rising Edge"
                                font.bold: true
                                onCheckedChanged: {
                                    if (checked) {
                                            dedgeSetPin.value = 1
                                            dedgeonOffSwitch.text = "Double Edge"
                                    }
                                    else {
                                        dedgeSetPin.value = 0
                                        dedgeonOffSwitch.text = "Rising Edge"
                                    }
                                }

                                Binding {
                                    target: dedgeonOffSwitch
                                    property: "checked"
                                    value: dedgeSetPin.value  > 0
                                }
                            }
                        }

                        RowLayout {// set mres values

                            id: mrescontrol
                            visible: true

                            Label {
                                id: mresLabel
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                font.bold: true
                                text: "Res"
                            }

                            HalSpinBox2 {
                                id: mresSetSpin
                                enabled: true
                                name: "mres.set"
                                halPin.direction: HalPin.IO
                                from: items.length - 1
                                to: 0// items.length - 1
    //                                 font.pixelSize: 30
    //                                 scale: 0.5

                                property var items: ["256", "128", "64", "32", "16", "8", "4", "2", "1"]

                                validator: RegExpValidator {
                                    regExp: new RegExp("(256|128|64|32|16|8|4|2|1)", "i")
                                }

                                textFromValue: function(value) {
                                    return items[value];
                                }

                                valueFromText: function(text) {
                                    for (var i = 0; i < items.length; ++i) {
                                        if (items[i].toLowerCase().indexOf(text.toLowerCase()) === 0)
                                            return i
                                    }
                                    return mressb.value
                                }
                            }

                            Label {
                                id: mresValsetLabel
                                font.bold: true
                                text: "uSteps   "
                            }

                            Switch2 {
                                id: mresonOffSwitch
                                enabled: true
/*
                                indicator: Rectangle {
                                    id: mresswitchHandle
                                    implicitWidth: root.themeBaseSize * 4.8
                                    implicitHeight: root.themeBaseSize * 1.3
                                    x: mresonOffSwitch.leftPadding
                                    anchors.verticalCenter: parent.verticalCenter
                                    radius: root.themeBaseSize * 1.3
                                    color: root.lightgrayColour
                                    border.color: root.darkgrayColour

                                    Rectangle {
                                        id: rectangle

                                        width: root.themeBaseSize * 2.6
                                        height: root.themeBaseSize * 2.6
                                        radius: root.themeBaseSize * 1.3
                                        anchors.verticalCenter: parent.verticalCenter
                                        color: root.themeKnob
                                        border.color: root.themeGray
                                    }

                                    states: [
                                        State {
                                            name: "off"
                                            when: !mresonOffSwitch.checked && !mresonOffSwitch.down
                                        },
                                        State {
                                            name: "on"
                                            when: mresonOffSwitch.checked && !mresonOffSwitch.down

                                            PropertyChanges {
                                                target: mresswitchHandle
                                                color: root.themeMainColor
                                                border.color: root.themeMainColor
                                            }

                                            PropertyChanges {
                                                target: rectangle
                                                x: parent.width - width

                                            }
                                        },
                                        State {
                                            name: "off_down"
                                            when: !mresonOffSwitch.checked && mresonOffSwitch.down

                                            PropertyChanges {
                                                target: rectangle
                                                color: root.themeLight
                                            }

                                        },
                                        State {
                                            name: "on_down"
                                            extend: "off_down"
                                            when: mresonOffSwitch.checked && mresonOffSwitch.down

                                            PropertyChanges {
                                                target: rectangle
                                                x: parent.width - width
                                                color: root.themeLight
                                            }

                                            PropertyChanges {
                                                target: mresswitchHandle
                                                color: root.themeMainColorDarker
                                                border.color: root.themeMainColorDarker
                                            }
                                        }
                                    ]
                                }
*/
                                onCheckedChanged: {
                                    if (checked) {
                                        if (mresSetSpin.value == 0) {
//                                        color: "white"
                                            checked = 0//root.lastMresValue
                                        }
                                    }
                                    else {
//                                        root.lastMresValue = mresSetSpin.value
//                                        color: "yellow"
    //                                            mresSetSpin.value = 0
                                    }
                                }

                                Binding {
                                    target: mresonOffSwitch
                                    property: "checked"
                                    value: mresSetSpin.value != 0//root.defMresValue
                                }
                            }
                        }

                        RowLayout {// set sgt values

                            id: sgtcontrol
                            visible: true

                        HalSpinBox2 {
                            id: sgtSetSpin
                            enabled: true
                            name: "sgt.set"
                            halPin.direction: HalPin.IO
                            from: -64
                            to: 63
    //                                 font.pixelSize: 30
    //                                 scale: 0.5

                                onValueModified: {            // remove the focus from this control
                                    parent.forceActiveFocus()
                                    parent.focus = true
                                }
                            }

                            Label {
                                id: sgtValsetLabel
                                font.bold: true
                                text: "SG2 threshold"
                            }

                            Switch2 {
                                id: sgtonOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
                                        if (sgtSetSpin.value == 0) {
                                            checked = 0//sgtSetSpin.value = root.lastSgtValue
                                        }
                                    }
//                                     else {
//                                         root.lastSgtValue = sgtSetSpin.value
//                                         sgtSetSpin.value = 0
//                                     }
                                }

                                Binding {
                                    target: sgtonOffSwitch
                                    property: "checked"
                                    value: sgtSetSpin.value  != 0
                                }
                            }
                        }

//                     Item {
//                         Layout.fillHeight: true
//                     }

                    }
                    Column {  // Second Column (Chopconf)

                        Label {  // Header
                            font.bold: true
                            text: qsTr("Chopconf:")
                        }

                        RowLayout {// set tbl values

                            id: tblcontrol
                            visible: true

                            HalSpinBox2 {
                                id: tblSetSpin
                                enabled: true
                                name: "tbl.set"
                                halPin.direction: HalPin.IO
                                from: 0//items.length - 1
                                to: items.length - 1
    //                                    value: 0
    //                                 font.pixelSize: 30
    //                                 scale: 0.5

                                property var items: ["16", "24", "36", "54"]

                                validator: RegExpValidator {
                                    regExp: new RegExp("(16|24|36|54)", "i")
                                }

                                textFromValue: function(value) {
                                    return items[value];
                                }

                                valueFromText: function(text) {
                                    for (var i = 0; i < items.length; ++i) {
                                        if (items[i].toLowerCase().indexOf(text.toLowerCase()) === 0)
                                            return i
                                    }
                                    return tblsb.value
                                }
                            }

                            Label {
                                id: tblValsetLabel
                                font.bold: true
                                text: "Blanking time"
                            }

                            Switch2 {
                                id: tblonOffSwitch
                                enabled: true
    //                               background.color: "blue"
                                onCheckedChanged: {
                                    if (checked) {
    //                                            if (tblSetSpin.value == 0) {
                                            tblSetSpin.value = root.lastTblValue
    //                                            }
                                    }
                                    else {
                                        root.lastTblValue = tblSetSpin.value
    //                                            tblSetSpin.value = 0
                                    }
                                }

                                Binding {
                                    target: tblonOffSwitch
                                    property: "checked"
                                    value: tblSetSpin.value  != root.defTblValue
                                }
                            }
                        }

                        RowLayout {// set chm values

                            id: chmcontrol
                            visible: true

                            Switch2 {
                                id: chmonOffSwitch
                                enabled: true
                                display: AbstractButton.TextBesideIcon
                                text: qsTr("Chopper mode")
                                font.bold: true
                                onCheckedChanged: {
                                    if (checked) {
                                            chmSetPin.value = 1
                                    }
                                    else {
                                        chmSetPin.value = 0
                                    }
                                }

                                Binding {
                                    target: chmonOffSwitch
                                    property: "checked"
                                    value: chmSetPin.value  > 0
                                }
                            }
                        }

                        RowLayout {// set rndtf values

                            id: rndtfcontrol
                            visible: true

                            Switch2 {
                                id: rndtfonOffSwitch
                                enabled: true
                                display: AbstractButton.TextBesideIcon
                                text: qsTr("Random TOFF time")
                                font.bold: true
                                onCheckedChanged: {
                                    if (checked) {
                                            rndtfSetPin.value = 1
                                    }
                                    else {
                                        rndtfSetPin.value = 0
                                    }
                                }

                                Binding {
                                    target: rndtfonOffSwitch
                                    property: "checked"
                                    value: rndtfSetPin.value  > 0
                                }
                            }
                        }

                        RowLayout {// set hdec1 values

                            id: hdec1control
                            visible: true

                            Switch2 {
                                id: hdec1onOffSwitch
                                enabled: true
                                display: AbstractButton.TextBesideIcon
                                text: qsTr("Hysteresis decrement period 1")
    //                                    text: qsTr("Fast decay mode")
                                font.bold: true
                                onCheckedChanged: {
                                    if (checked) {
                                            hdec1SetPin.value = 1
                                    }
                                    else {
                                        hdec1SetPin.value = 0
                                    }
                                }

                                Binding {
                                    target: hdec1onOffSwitch
                                    property: "checked"
                                    value: hdec1SetPin.value  > 0
                                }
                            }
                        }

                        RowLayout {// set hdec0 values

                            id: hdec0control
                            visible: true

                            Switch2 {
                                id: hdec0onOffSwitch
                                enabled: true
                                display: AbstractButton.TextBesideIcon
                                text: qsTr("Hysteresis decrement period 0")
    //                                    text: qsTr("Fast decay mode")
                                font.bold: true
                                onCheckedChanged: {
                                    if (checked) {
                                            hdec0SetPin.value = 1
                                    }
                                    else {
                                        hdec0SetPin.value = 0
                                    }
                                }

                                Binding {
                                    target: hdec0onOffSwitch
                                    property: "checked"
                                    value: hdec0SetPin.value  > 0
                                }
                            }
                        }

                        RowLayout {// set hend values

                            id: hendcontrol
                            visible: true

                        HalSpinBox2 {
                            id: hendSetSpin
                            enabled: true
                            name: "hend.set"
                            halPin.direction: HalPin.IO
                            from: -3
                            to: 12
                            // chm =0
    //                                 font.pixelSize: 30
    //                                 scale: 0.5

                                onValueModified: {            // remove the focus from this control
                                    parent.forceActiveFocus()
                                    parent.focus = true
                                }
                            }

                            Label {
                                id: hendValsetLabel
                                font.bold: true
                                text: "Hysteresis end (low)"
                            }

                            Switch2 {
                                id: hendonOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
    //                                            if (hendSetSpin.value == 0) {
                                            hendSetSpin.value = root.lastHendValue
    //                                            }
                                    }
                                    else {
                                        root.lastHendValue = hendSetSpin.value
    //                                            hendSetSpin.value = 0
                                    }
                                }

                                Binding {
                                    target: hendonOffSwitch
                                    property: "checked"
                                    value: hendSetSpin.value  != root.defHendValue
                                }
                            }
                        }

                        RowLayout {// set hstrt values

                            id: hstrtcontrol
                            visible: true

                            HalSpinBox2 {
                                id: hstrtSetSpin
                                enabled: true
                                name: "hstrt.set"
                                halPin.direction: HalPin.IO
                                from: 0 //items.length - 1
                                to: items.length - 1
    //                                    value: 0
    //                                 font.pixelSize: 30
    //                                 scale: 0.5
                                // if chm = 0
                                property var items: ["1", "2", "3", "4", "5", "6", "7", "8"]

                                validator: RegExpValidator {
                                    regExp: new RegExp("(1|2|3|4|5|6|7|8)", "i")
                                }

                                textFromValue: function(value) {
                                    return items[value];
                                }

                                valueFromText: function(text) {
                                    for (var i = 0; i < items.length; ++i) {
                                        if (items[i].toLowerCase().indexOf(text.toLowerCase()) === 0)
                                            return i
                                    }
                                    return hstrtsb.value
                                }
                            }

                            Label {
                                id: hstrtValsetLabel
                                font.bold: true
                                text: "Hysteresis start value"
                            }

                            Switch2 {
                                id: hstrtonOffSwitch
                                enabled: true
    //                               background.color: "blue"
                                onCheckedChanged: {
                                    if (checked) {
    //                                            if (hstrtSetSpin.value == 0) {
                                            hstrtSetSpin.value = root.lastHstrtValue
    //                                            }
                                    }
                                    else {
                                        root.lastHstrtValue = hstrtSetSpin.value
                                        hstrtSetSpin.value = 0
                                    }
                                }

                                Binding {
                                    target: hstrtonOffSwitch
                                    property: "checked"
                                    value: hstrtSetSpin.value  != root.defHstrtValue
                                }
                            }
                        }

                        RowLayout {// set toff values

                            id: toffcontrol
                            visible: true

                            HalSpinBox2 {
                                id: toffSetSpin
    //                                    hoverEnabled: true
                                enabled: true
                                name: "toff.set"
                                halPin.direction: HalPin.IO

                                from: 0
                                to: 15
    //                                    value: 16
    //                                ToolTip.visible: down
                                ToolTip.delay: 1000
    //                                ToolTip.timeout: 2000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("0000: Driver disable, all bridges off\n0001: 1 (use with TBL of minimum 24 clocks)\n0010 ... %1111: 2 ... 15")
                                // chm =0
    //                                 font.pixelSize: 30
    //                                 scale: 0.5

                                    onValueModified: {            // remove the focus from this control
                                        parent.forceActiveFocus()
                                        parent.focus = true
                                    }
                                }

                            Label {
                                id: toffdValsetLabel
                                font.bold: true
                                text: "Off time/MOSFET"
                            }
    /*
                            Switch2 {
                                id: toffonOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
    //                                            if (toffSetSpin.value == 0) {
                                            toffSetSpin.value = root.lastToffValue
    //                                            }
                                    }
                                    else {
                                        root.lastToffValue = toffSetSpin.value
    //                                            toffSetSpin.value = 0
                                    }
                                }

                                Binding {
                                    target: toffonOffSwitch
                                    property: "checked"
                                    value: toffSetSpin.value  != root.defToffValue
                                }
                            }
    */
                        }
                    }

                    Column {  // third Column (Smarten)

                        Label {
                            font.bold: true
                            text: qsTr("Smarten:")
                        }

                    }

                    Column { // Forth Column (Sgsconf)

                        Label {
                            font.bold: true
                            text: qsTr("Sgcsconf:")
                        }

                    }
                }

                Item {
                    Layout.fillHeight: true
                }
            }
        }


        Item {
            Layout.fillHeight: true
        }
    }


    ApplicationNotifications {
        id: applicationNotifications
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.margins: Screen.pixelDensity
        messageWidth: parent.width * 0.25
    }
}










