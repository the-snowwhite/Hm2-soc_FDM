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
import "./Controls"
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
    property double lastSgtValue
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
// + string( " %1" ).arg( 15, 1, 16 ).toUpper()
//    name: "TrinamicSPI"
//    title: qsTr("Trinamic SPI Test")
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

        RowLayout {
            ColumnLayout {
                Layout.preferredWidth: 20
                ColumnLayout {
                    Label {
                        id: ststLabel
                        font.bold: true
                        text: "stst"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    HalLed {
                        id: ststLed
                        name: "stst.status"
                        onColor: "yellow"
                        Layout.preferredHeight: ststLabel.height * 0.9
                        Layout.preferredWidth: ststLabel.height * 0.9
                    }
                }

                ColumnLayout {
                    Label {
                        id: olbLabel
                        font.bold: true
                        text: "olb"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    HalLed {
                        id: olbLed
                        name: "olb.status"
                        onColor: "red"
                        Layout.preferredHeight: olbLabel.height * 0.9
                        Layout.preferredWidth: olbLabel.height * 0.9
                    }
                }

                ColumnLayout {
                    Label {
                        id: olaLabel
                        font.bold: true
                        text: "ola"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    HalLed {
                        id: olaLed
                        name: "ola.status"
                        onColor: "red"
                        Layout.preferredHeight: olaLabel.height * 0.9
                        Layout.preferredWidth: olaLabel.height * 0.9
                    }
                }

                ColumnLayout {
                    Label {
                        id: s2gbLabel
                        font.bold: true
                        text: "s2gb"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    HalLed {
                        id: s2gbLed
                        name: "s2gb.status"
                        onColor: "red"
                        Layout.preferredHeight: s2gbLabel.height * 0.9
                        Layout.preferredWidth: s2gbLabel.height * 0.9
                    }
                }

                ColumnLayout {
                    Label {
                        id: s2gaLabel
                        font.bold: true
                        text:" s2ga"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    HalLed {
                        id: s2gaLed
                        name: "s2ga.status"
                        onColor: "red"
                        Layout.preferredHeight: s2gaLabel.height * 0.9
                        Layout.preferredWidth: s2gaLabel.height * 0.9
                    }
                }

                ColumnLayout {
                    Label {
                        id: otpwLabel
                        font.bold: true
                        text: "otpw"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    HalLed {
                        id: otpwLed
                        name: "otpw.status"
                        onColor: "red"
                        Layout.preferredHeight: otpwLabel.height * 0.9
                        Layout.preferredWidth: otpwLabel.height * 0.9
                    }
                }

                ColumnLayout {
                    Label {
                        id: otLabel
                        font.bold: true
                        text: "ot"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    HalLed {
                        id: otLed
                        name: "ot.status"
                        onColor: "red"
                        Layout.preferredHeight: otLabel.height * 0.9
                        Layout.preferredWidth: otLabel.height * 0.9
                    }
                }

                ColumnLayout {
                    Label {
                        id: sgLabel
                        font.bold: true
                        text: "sg"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    HalLed {
                        id: sgLed
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

            ColumnLayout {
                id: transport
                ApplicationStatusBar { id: applicationStatusBar }

                RowLayout {
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

                RowLayout {
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

                RowLayout {
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

                JogVelocitySlider {
                    id: jogVelocitySlider
                    Layout.fillWidth: true
                    axis: axisRadioGroup.axis
                    proportional: false
                }

                RowLayout {
                    RowLayout {
                        id: readout
                        anchors.margins: 10
                        Layout.fillHeight: true
                        Layout.fillWidth: true

                        Column {
                            spacing: 10// Layout.fillWidth: true

                            Text {
                                text: "Trinamic SPI registers"
                                color: "black"// color can be set on the entire element with this property

                            }

                            Rectangle { // button
                                height: 120; width: parent.width
                                color: "white"//mouseArea2.pressed ? "black" : "gray"
                                Text {
                                    id: regTxt
                                    text: root.regValues


                                    color: "black"// color can be set on the entire element with this property

                                }
                            }

                            Rectangle {
                                height: 48; width: parent.width// color: mouseArea2.pressed ? "black" : "gray"
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
                                }
                            }

                            RowLayout {// set intpol values

                                id: intpolcontrol
                                visible: true

    //                             Item {
    //                                 Layout.fillWidth: true
    //                            }

                                Switch {
                                    id: intpolonOffSwitch
                                    enabled: true
                                    text: "Interpolation"
                                    font.bold: true
                                    onCheckedChanged: {
                                        if (checked) {
                                                intpolSetPin.value = 1
                                        }
                                        else {
                                            intpolSetPin.value = 0
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

    //                             Item {
    //                                 Layout.preferredWidth: regTxt.width - dedgeValsetLabel.width - dedgeonOffSwitch.width + window.anchors.margins
    //                             }

                                Switch {
                                    id: dedgeonOffSwitch
                                    enabled: true
                                    display: AbstractButton.TextBesideIcon
                                    text: qsTr("Doubleedge")
                                    font.bold: true
                                    onCheckedChanged: {
                                        if (checked) {
                                                dedgeSetPin.value = 1
                                        }
                                        else {
                                            dedgeSetPin.value = 0
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

                                HalSpinBox2 {
                                    id: mresSetSpin
                                    enabled: true
                                    name: "mres.set"
                                    halPin.direction: HalPin.IO
                                    from: items.length - 1
                                    to: 0// items.length - 1
                                    value: 0
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
                                    text: "Microsteps   "
                                }

                                Switch {
                                    id: mresonOffSwitch
                                    enabled: true
    //                               background.color: "blue"
                                    onCheckedChanged: {
                                        if (checked) {
                                            if (mresSetSpin.value == 0) {
                                                mresSetSpin.value = root.lastMresValue
                                            }
                                        }
                                        else {
                                            root.lastMresValue = mresSetSpin.value
                                            mresSetSpin.value = 0
                                        }
                                    }

                                    Binding {
                                        target: mresonOffSwitch
                                        property: "checked"
                                        value: mresSetSpin.value  > 0
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
                                    text: "SG threshold"
                                }

                                Switch {
                                    id: sgtonOffSwitch
                                    enabled: true
                                    onCheckedChanged: {
                                        if (checked) {
                                            if (sgtSetSpin.value == 0) {
                                                sgtSetSpin.value = root.lastSgtValue
                                            }
                                        }
                                        else {
                                            root.lastSgtValue = sgtSetSpin.value
                                            sgtSetSpin.value = 0
                                        }
                                    }

                                    Binding {
                                        target: sgtonOffSwitch
                                        property: "checked"
                                        value: sgtSetSpin.value  != 0
                                    }
                                }
                            }

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


                HalGauge {
                    id: sgGauge
                    Layout.fillWidth: true
                    name: "sg.val"
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
                        anchors.centerIn: parent
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










