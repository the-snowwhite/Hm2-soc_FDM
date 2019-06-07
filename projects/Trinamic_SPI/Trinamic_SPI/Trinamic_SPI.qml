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
    property double gaugeZ0BorderValue: 50.0
    property double gaugeMinimumValue: 0
    property double gaugeMaximumValue: 1024
    property double gaugeZ1BorderValue: gaugeMaximumValue * 0.9
    property double savedMresValue
    property double savedTblValue
    property double savedHendValue
    property double savedHstrtValue
    property double savedToffValue
    property double savedSednValue
    property double savedSemaxValue
    property double savedSeupValue
    property double savedSeminValue
    property double savedSgtValue
    property double savedCsValue
    property double savedSiphValue
    property double savedSiplValue
    property double savedTs2gValue
    property double savedRdselValue

    property bool defIntpolValue
    property bool defDedgeValue
    property double defMresValue

    property double defTblValue
    property bool defChmValue
    property bool defRndtfValue
    property bool defHdec1Value
    property bool defHdec0Value
    property double defHendValue
    property double defHstrtValue
    property double defToffValue

    property bool defSeiminValue
    property double defSednValue
    property double defSemaxValue
    property double defSeupValue
    property double defSeminValue


    property bool defSfiltValue
    property double defSgtValue
    property double defCsValue

    property bool defTstValue
    property double defSlphValue
    property double defSlplValue
    property bool defDiss2gValue
    property double defTs2gValue
    property bool defSdoffValue
    property bool defVsenseValue
    property double defRdselValue

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
    property string fullreadresponseValue_3: "Read Response 3: \t  0x" + fullreadresponsePin_3.value.toString(16).toUpperCase()
    property string fullreadresponseValue_4: "Read Response 4: \t  0x" + fullreadresponsePin_4.value.toString(16).toUpperCase()
    property int themeBaseSize: 10
    property string lightgrayColour: "light green"
    property string darkgrayColour: "gray"
    property string themeLight: "blue"
    property string themeKnob: "white"
    property string themeLightGray: "light gray"
    property string themeGray: "gray"
//    property string themeMainColor: "black"
    property string themeMainColor: "light green"
    property string themeMainColorDarker: "orange"
    Component.onCompleted: { timer.setTimeout(function(){ g.dlymsg(1); }, 260 + 100); }
    title: applicationCore.applicationName + (d.machineName === "" ? "" :" - " +  d.machineName)

    statusBar:applicationStatusBar
    toolBar: applicationToolBar
//    menuBar: applicationMenuBar

    Timer {
        id: timer
        function setTimeout(cb, delayTime) {
            timer.interval = delayTime;
            timer.repeat = false;
            timer.triggered.connect(cb);
            timer.triggered.connect(function release () {
                timer.triggered.disconnect(cb); // This is important
                timer.triggered.disconnect(release); // This is important as well
            });
            timer.start();
        }
    }

    QtObject {
        id: g

        function dlymsg(x) {
            if(x==1) {
                root.defIntpolValue = intpolSetPin.value
                root.defDedgeValue = dedgeSetPin.value
                root.defMresValue = mresSetSpin.value
                root.defTblValue = tblSetSpin.value
                root.defChmValue = chmSetPin.value
                root.defRndtfValue = rndtfSetPin.value
                root.defHdec1Value = hdec1SetPin.value
                root.defHdec0Value = hdec0SetPin.value
                root.defHendValue = hendSetSpin.value
                root.defHstrtValue = hstrtSetSpin.value
                root.defToffValue = toffSetSpin.value
                root.defSeiminValue = seiminSetPin.value
                root.defSednValue = sednSetSpin.value
                root.defSemaxValue = semaxSetSpin.value
                root.defSeupValue = seupSetSpin.value
                root.defSeminValue = seminSetSpin.value
                root.defSfiltValue = sfiltSetPin.value
                root.defSgtValue = sgtSetSpin.value
                root.defCsValue = csSetSpin.value
                root.defTstValue = tstSetPin.value
                root.defSlphValue = slphSetSpin.value
                root.defSlplValue = slplSetSpin.value
                root.defDiss2gValue = diss2gSetPin.value
                root.defTs2gValue = ts2gSetSpin.value
                root.defSdoffValue = sdoffSetPin.value
                root.defVsenseValue = vsenseSetPin.value
                root.defRdselValue = rdselSetSpin.value
            }
        }
    }

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
                id: fullreadresponsePin_3
                name: "full.3.val"
                direction: HalPin.In
                type: HalPin.U32
            }

            HalPin {
                id: fullreadresponsePin_4
                name: "full.4.val"
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

            HalPin {
                id: seiminSetPin
                name: "seimin.set"
                direction: HalPin.IO
                type: HalPin.Bit
            }

            HalPin {
                id: sfiltSetPin
                name: "sfilt.set"
                direction: HalPin.IO
                type: HalPin.Bit
            }

            HalPin {
                id: tstSetPin
                name: "tst.set"
                direction: HalPin.IO
                type: HalPin.Bit
            }

            HalPin {
                id: diss2gSetPin
                name: "diss2g.set"
                direction: HalPin.IO
                type: HalPin.Bit
            }

            HalPin {
                id: sdoffSetPin
                name: "sdoff.set"
                direction: HalPin.IO
                type: HalPin.Bit
            }

            HalPin {
                id: vsenseSetPin
                name: "vsense.set"
                direction: HalPin.IO
                type: HalPin.Bit
            }
        }

        RowLayout {
            ColumnLayout { // Status leds
                Layout.preferredWidth: 50
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
                                height: 120; width: parent.width// color: mouseArea2.pressed ? "black" : "gray"
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
                                    Text {
                                        id: readresponseTxt_3
                                        text: root.fullreadresponseValue_3
                                        color: "black"// color can be set on the entire element with this property
                                    }
                                    Text {
                                        id: readresponseTxt_4
                                        text: root.fullreadresponseValue_4
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
                        visible: true
                        value: sgGauge.value
                        minimumValue: sgGauge.minimumValue
                        maximumValue: sgGauge.maximumValue
                        leftTextVisible: false
                        rightTextVisible: false
                        autoSampling: (sgGauge.halPin.synced) && visible
                        autoUpdate: autoSampling
                        updateInterval: 250
                        timeSpan: 120000
                        Layout.maximumHeight: 256
                        Layout.maximumWidth: 1024
                        gridColor: qsTr("#eeeeee")
                        backgroundColor: qsTr("#ffffff")
                    }
                }

                RowLayout {  // Settings row
                    Column {  // First Column (Drvctrl)
                        spacing: 10// Layout.fillWidth: true
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Label {
                            font.bold: true
                            text: qsTr("Drvctrl:")
                        }

                        RowLayout {// set intpol bit

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
                                    property: "down"
                                    value: intpolSetPin.value  != root.defIntpolValue
                                }
                            }
                        }

                        RowLayout {// set dedge bit

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
                                    property: "down"
                                    value: dedgeSetPin.value  != root.defDedgeValue
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
                                text: "μSt"
                            }

                            Switch2 {
                                id: mresonOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
                                        if (mresSetSpin.value != root.savedMresValue) {
                                            root.savedMresValue = mresSetSpin.value
                                        }
                                    }
                                    else {
                                        mresSetSpin.value = root.savedMresValue
                                    }
                                }

                                Binding {
                                    target: mresonOffSwitch
                                    property: "down"
                                    value: mresSetSpin.value != root.defMresValue
                                }
                            }
                        }

//                     Item {
//                         Layout.fillHeight: true
//                     }

                    }

                    Column {  // Second Column (Chopconf)
                        spacing: 10// Layout.fillWidth: true
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Label {  // Header
                            font.bold: true
                            text: qsTr("Chopconf:")
                        }

                        RowLayout {// set tbl values

                            id: tblcontrol
                            visible: true

                            HalSpinBox2 {
                                id: tblSetSpin
//                                property double defTbl

                                enabled: true
                                name: "tbl.set"
                                halPin.direction: HalPin.IO
                                from: 0//items.length - 1
                                to: items.length - 1
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
                                    return tblSetSpin.value
                                }
                            }

                            Label {
                                id: tblValsetLabel
                                font.bold: true
                                text: "Blank time"
                            }

                            Switch2 {
                                id: tblonOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
                                        if (tblSetSpin.value != root.savedTblValue) {
                                            root.savedTblValue = tblSetSpin.value
                                        }
                                    }
                                    else {
                                        tblSetSpin.value = root.savedTblValue
                                    }
                                }
                                 Binding {
                                     target: tblonOffSwitch
                                     property: "down"
                                     value: tblSetSpin.value  != root.defTblValue
                                 }
                            }

                        }

                        RowLayout {// set chm bit

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
                                    property: "down"
                                    value: chmSetPin.value  != root.defChmValue
                                }
                            }
                        }

                        RowLayout {// set rndtf bit

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
                                    property: "down"
                                    value: rndtfSetPin.value  != root.defRndtfValue
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
                                    property: "down"
                                    value: hdec1SetPin.value  != root.defHdec1Value
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
                                    property: "down"
                                    value: hdec0SetPin.value != root.defHdec0Value
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
                                text: "Hys end (lo)"
                            }

                            Switch2 {
                                id: hendonOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
                                        if (hendSetSpin.value != root.savedHendValue) {
                                            root.savedHendValue = hendSetSpin.value
                                        }
                                    }
                                    else {
                                        hendSetSpin.value = root.savedHendValue
                                    }
                                }

                                Binding {
                                    target: hendonOffSwitch
                                    property: "down"
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
                                text: "Hys start val"
                            }

                            Switch2 {
                                id: hstrtonOffSwitch
                                enabled: true
    //                               background.color: "blue"
                                onCheckedChanged: {
                                    if (checked) {
                                        if (hstrtSetSpin.value != root.savedHstrtValue) {
                                            root.savedHstrtValue = hstrtSetSpin.value
                                        }
                                    }
                                    else {
                                        hstrtSetSpin.value = root.savedHstrtValue
                                    }
                                }

                                Binding {
                                    target: hstrtonOffSwitch
                                    property: "down"
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
                                text: "Off t/MFET"
                            }

                            Switch2 {
                                id: toffonOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
                                                if (toffSetSpin.value != root.savedToffValue) {
                                            root.savedToffValue = toffSetSpin.value
                                                }
                                    }
                                    else {
                                        toffSetSpin.value = root.savedToffValue
                                    }
                                }

                                Binding {
                                    target: toffonOffSwitch
                                    property: "down"
                                    value: toffSetSpin.value  != root.defToffValue
                                }
                            }
                        }
                    }

                    Column {  // third Column (Smarten)
                        spacing: 10// Layout.fillWidth: true
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Label {
                            font.bold: true
                            text: qsTr("Smarten:")
                        }

                        RowLayout {// set seimin bit

                            id: seimincontrol
                            visible: true

                            Label {
                                id: seiminLabel
//                                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                                font.bold: true
                                text:"Minimum coolStep curren"
                            }

                            Switch2 {
                                id: seiminonOffSwitch
                                enabled: true
                                display: AbstractButton.TextBesideIcon
                                text: seiminSetPin.value  > 0 ? "1⁄4 CS" : "1⁄2 CS"
    //                                    text: qsTr("Fast decay mode")
                                font.bold: true
                                onCheckedChanged: {
                                    if (checked) {
                                            seiminSetPin.value = 1
                                            seiminonOffSwitch.text = "1⁄4 CS"
                                    }
                                    else {
                                        seiminSetPin.value = 0
                                        seiminonOffSwitch.text = "1⁄2 CS"
                                    }
                                }

                                Binding {
                                    target: seiminonOffSwitch
                                    property: "down"
                                    value: seiminSetPin.value  != root.defSeiminValue
                                }
                            }
                        }

                        RowLayout {// set sedn values

                            id: sedncontrol
                            visible: true

                            Label {
                                id: sednValsetLabel
                                font.bold: true
                                text: "Cur dec spd"
                            }

                            HalSpinBox2 {
                                 id: sednSetSpin
//                                property double defSedn

                                enabled: true
                                name: "sedn.set"
                                halPin.direction: HalPin.IO
                                from: 0//items.length - 1
                                to: items.length - 1
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("Number of times that the stallGuard2 value must be\nsampled equal to or above the upper threshold for each\ndecrement of the coil current:")
    //                                 font.pixelSize: 30
    //                                 scale: 0.5

                                property var items: ["32", "8", "2", "1"]

                                validator: RegExpValidator {
                                    regExp: new RegExp("(32|6|2|1)", "i")
                                }

                                textFromValue: function(value) {
                                    return items[value];
                                }

                                valueFromText: function(text) {
                                    for (var i = 0; i < items.length; ++i) {
                                        if (items[i].toLowerCase().indexOf(text.toLowerCase()) === 0)
                                            return i
                                    }
                                    return sednSetSpin.value
                                }
                            }

                            Switch2 {
                                id: sednonOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
                                        if (sednSetSpin.value != root.savedSednValue) {
                                            root.savedSednValue = sednSetSpin.value
                                        }
                                    }
                                    else {
                                        sednSetSpin.value = root.savedSednValue
                                    }
                                }
                                 Binding {
                                     target: sednonOffSwitch
                                     property: "down"
                                     value: sednSetSpin.value  != root.defSednValue
                                 }
                            }

                        }

                        RowLayout {// set semax values

                            id: semaxcontrol
                            visible: true

                            Label {
                                id: semaxValsetLabel
                                font.bold: true
                                text: "Up CS trs offs"
                            }

                            HalSpinBox2 {
                                id: semaxSetSpin
//                                property double defSemax

                                enabled: true
                                name: "semax.set"
                                halPin.direction: HalPin.IO
                                from: 0
                                to: 15
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("If the stallGuard2 measurement value SG is sampled\nequal to or above (SEMIN+SEMAX+1) x 32 enough times,\nthen the coil current scaling factor is decremented.")
    //                                 font.pixelSize: 30
    //                                 scale: 0.5

                                onValueModified: {            // remove the focus from this control
                                    parent.forceActiveFocus()
                                    parent.focus = true
                                }

                            }

                            Switch2 {
                                id: semaxonOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
                                        if (semaxSetSpin.value != root.savedSemaxValue) {
                                            root.savedSemaxValue = semaxSetSpin.value
                                        }
                                    }
                                    else {
                                        semaxSetSpin.value = root.savedSemaxValue
                                    }
                                }
                                Binding {
                                    target: semaxonOffSwitch
                                    property: "down"
                                    value: semaxSetSpin.value  != root.defSemaxValue
                                }
                            }

                        }

                        RowLayout {// set seup values

                            id: seupcontrol
                            visible: true

                            Label {
                                id: seupValsetLabel
                                font.bold: true
                                text: "Curr incr size"
                            }

                            HalSpinBox2 {
                                id: seupSetSpin
//                                property double defSeup

                                enabled: true
                                name: "seup.set"
                                halPin.direction: HalPin.IO
                                from: 0//items.length - 1
                                to: items.length - 1
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("Number of current increment steps for each time that\nthe stallGuard2 value SG is sampled below the lower\nthreshold:")
    //                                 font.pixelSize: 30
    //                                 scale: 0.5

                                property var items: ["1", "2", "4", "8"]

                                validator: RegExpValidator {
                                    regExp: new RegExp("(1|2|4|8)", "i")
                                }

                                textFromValue: function(value) {
                                    return items[value];
                                }

                                valueFromText: function(text) {
                                    for (var i = 0; i < items.length; ++i) {
                                        if (items[i].toLowerCase().indexOf(text.toLowerCase()) === 0)
                                            return i
                                    }
                                    return seupSetSpin.value
                                }
                            }

                            Switch2 {
                                id: seuponOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
                                        if (seupSetSpin.value != root.savedSeupValue) {
                                            root.savedSeupValue = seupSetSpin.value
                                        }
                                    }
                                    else {
                                        seupSetSpin.value = root.savedSeupValue
                                    }
                                }
                                 Binding {
                                     target: seuponOffSwitch
                                     property: "down"
                                     value: seupSetSpin.value  != root.defSeupValue
                                 }
                            }

                        }

                        RowLayout {// set semin values

                            id: semincontrol
                            visible: true

                                Label {
                                    id: seminValsetLabel
                                    font.bold: true
                                    text: "Lo CS trs offs"
                                }

                            HalSpinBox2 {
                                id: seminSetSpin
//                                property double defSemin

                                enabled: true
                                name: "semin.set"
                                halPin.direction: HalPin.IO
                                from: 0
                                to: 15
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("If SEMIN is 0, coolStep is disabled. If SEMIN is nonzero\nand the stallGuard2 value SG falls below SEMIN x 32,\nthe coolStep current scaling factor is increased.")
    //                                 font.pixelSize: 30
    //                                 scale: 0.5

                                onValueModified: {            // remove the focus from this control
                                    parent.forceActiveFocus()
                                    parent.focus = true
                                }
                            }

                            Switch2 {
                                id: seminonOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
                                        if (seminSetSpin.value != root.savedSeminValue) {
                                            root.savedSeminValue = seminSetSpin.value
                                        }
                                    }
                                    else {
                                        seminSetSpin.value = root.savedSeminValue
                                    }
                                }
                                Binding {
                                    target: seminonOffSwitch
                                    property: "down"
                                    value: seminSetSpin.value  != root.defSeminValue
                                }
                            }

                        }
                    }

                    Column { // Forth Column (Sgsconf)
                        spacing: 10// Layout.fillWidth: true
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Label {
                            font.bold: true
                            text: qsTr("Sgcsconf:")
                        }

                        RowLayout {// set sfilt bit

                            id: sfiltcontrol
                            visible: true

                            Switch2 {
                                id: sfiltonOffSwitch
                                enabled: true
                                display: AbstractButton.TextBesideIcon
                                text: sfiltSetPin.value  > 0 ? "SG2 filter enabled" : "SG2 filter disabled"
    //                                    text: qsTr("Fast decay mode")
                                font.bold: true
                                onCheckedChanged: {
                                    if (checked) {
                                            sfiltSetPin.value = 1
                                            sfiltonOffSwitch.text = "SG2 filter enabled"
                                    }
                                    else {
                                        sfiltSetPin.value = 0
                                        sfiltonOffSwitch.text = "SG2 filter disabled"
                                    }
                                }

                                Binding {
                                    target: sfiltonOffSwitch
                                    property: "down"
                                    value: sfiltSetPin.value  != root.defSfiltValue
                                }
                            }
                        }

                        RowLayout {// set sgt values

                            id: sgtcontrol
                            visible: true

                            Label {
                                id: sgtLabel
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                font.bold: true
                                text: "SG2 thres"
                            }

                            HalSpinBox2 {
                                id: sgtSetSpin
                                enabled: true
                                name: "sgt.set"
                                halPin.direction: HalPin.IO
                                from: -64
                                to: 63
        //                                 font.pixelSize: 30
        //                                 scale: 0.5
                                ToolTip.delay: 1000
//                                ToolTip.timeout: 2000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("The stallGuard2 threshold value controls the optimum\n" +
                                "measurement range for readout. A lower value results in\n" +
                                "a higher sensitivity and requires less torque to indicate\n" +
                                "a stall. The value is a two’s complement signed integer.\n" +
                                "Values below -10 are not recommended.\n" +
                                "Range: -64 to +63\n" +
                                " Tuning the stallGuard2 Threshold\n" +
                                "Due to the dependency of the stallGuard2 value SG from motor-specific characteristics and application-\n" +
                                "specific demands on load and velocity the easiest way to tune the stallGuard2 threshold SGT for a\n" +
                                "specific motor type and operating conditions is interactive tuning in the actual application.\n" +
                                "The procedure is:\n" +
                                "1. Operate the motor at a reasonable velocity for your application and monitor SG.\n" +
                                "2. Apply slowly increasing mechanical load to the motor. If the motor stalls before SG reaches\n" +
                                "zero, decrease SGT. If SG reaches zero before the motor stalls, increase SGT. A good SGT\n" +
                                "starting value is zero. SGT is signed, so it can have negative or positive values.\n" +
                                "3. The optimum setting is reached when SG is between 0 and 400 at increasing load shortly\n" +
                                "before the motor stalls, and SG increases by 100 or more without load. SGT in most cases can\n" +
                                "be tuned together with the motion velocity in a way that SG goes to zero when the motor\n" +
                                "stalls and the stall output SG_TST is asserted. This indicates that a step has been lost.\n")



                                    onValueModified: {            // remove the focus from this control
                                        parent.forceActiveFocus()
                                        parent.focus = true
                                    }
                                }

                            Switch2 {
                                id: sgtonOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
                                        if (sgtSetSpin.value != root.savedSgtValue) {
                                            root.savedSgtValue = sgtSetSpin.value
                                        }
                                    }
                                    else {
                                        sgtSetSpin.value = root.savedSgtValue
                                    }
                                }

                                Binding {
                                    target: sgtonOffSwitch
                                    property: "down"
                                    value: sgtSetSpin.value  != root.defSgtValue
                                }
                            }
                        }

                        RowLayout {// set cs values

                            id: cscontrol
                            visible: true

                            Label {
                                id: csLabel
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                font.bold: true
                                text: "Curr scale"
                            }

                            HalSpinBox2 {
                                id: csSetSpin
                                enabled: true
                                name: "cs.set"
                                halPin.direction: HalPin.IO
                                from: 0//items.length - 1
                                to: items.length - 1
                                ToolTip.delay: 1000
//                                ToolTip.timeout: 2000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: "Current scaling for SPI and step/direction operation.\n%00000 ... %11111: 1/32, 2/32, 3/32, ... 32/32\nThis value is biased by 1 and divided by 32, so the\nrange is 1/32 to 32/32.\nExample: CS=0 is 1/32 current"

                                property var items: ["1/32", "2/32", "3/32", "4/32", "5/32", "6/32", "7/32", "8/32", "9/32",
                                    "10/32", "11/32", "12/32", "13/32", "14/32", "15/32", "16/32", "17/32", "18/32", "19/32",
                                    "20/32", "21/32", "22/32", "23/32", "24/32", "25/32", "26/32", "27/32", "28/32", "29/32",
                                    "30/32", "31/32", "32/32"]

                                validator: RegExpValidator {
                                    regExp: new RegExp("(1/32|2/32|3/32|4/32|5/32|6/32|7/32|8/32|9/32|10/32|11/32|12/32|13/32|14/32|15/32|16/32
                                        17/32|18/32|19/32|20/32|21/32|22/32|23/32|24/32|25/32|26/32|27/32|28/32|29/32|30/32|31/32|32/32)", "i")
                                }

                                textFromValue: function(value) {
                                    return items[value];
                                }

                                valueFromText: function(text) {
                                    for (var i = 0; i < items.length; ++i) {
                                        if (items[i].toLowerCase().indexOf(text.toLowerCase()) === 0)
                                            return i
                                    }
                                    return cssb.value
                                }
                            }

                            Switch2 {
                                id: csonOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
                                        if (csSetSpin.value != root.savedCsValue) {

                                            root.savedCsValue = csSetSpin.value
                                        }
                                    }
                                    else {
                                        csSetSpin.value = root.savedCsValue
                                    }
                                }

                                Binding {
                                    target: csonOffSwitch
                                    property: "down"
                                    value: csSetSpin.value != root.defCsValue
                                }
                            }
                        }
                    }

                    Column { // Fith Column (Drvconf)
                        spacing: 10// Layout.fillWidth: true
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Label {
                            font.bold: true
                            text: qsTr("Drvconf:")
                        }

                        RowLayout {// set tst bit

                            id: tstcontrol
                            visible: true

                            Switch2 {
                                id: tstonOffSwitch
                                enabled: true
                                display: AbstractButton.TextBesideIcon
                                text: tstSetPin.value  > 0 ? "Reserved TEST mode enable" : "Reserved TEST mode disabled"
    //                                    text: qsTr("Fast decay mode")
                                font.bold: true
                                ToolTip.delay: 1000
//                                ToolTip.timeout: 2000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("Must be cleared for normal operation. When set, the\nSG_TST output exposes digital test values, and the\nTEST_ANA output exposes analog test values. Test value\nselection is controlled by SGT1 and SGT0:\nTEST_ANA:\n %00: anatest_2vth,\n%01: anatest_dac_out,\n%10: anatest_vdd_half.\nSG_TST:\n%00: comp_A,\n%01: comp_B,\n%10: CLK,\n%11: on_state_xy")

                                onCheckedChanged: {
                                    if (checked) {
                                            tstSetPin.value = 1
                                            tstonOffSwitch.text = "Reserved TEST mode enabled"
                                    }
                                    else {
                                        tstSetPin.value = 0
                                        tstonOffSwitch.text = "Reserved TEST mode disabled"
                                    }
                                }

                                Binding {
                                    target: tstonOffSwitch
                                    property: "down"
                                    value: tstSetPin.value  != root.defTstValue
                                }
                            }
                        }

                        RowLayout {// set slph values

                            id: slphcontrol
                            visible: true

                            Label {
                                id: slphLabel
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                font.bold: true
                                text: "Slope ctrl, high"
                            }

                            HalSpinBox2 {
                                id: slphSetSpin
                                enabled: true
                                name: "slph.set"
                                halPin.direction: HalPin.IO
                                from: 0
                                to:3
        //                                 font.pixelSize: 30
        //                                 scale: 0.5
                                ToolTip.delay: 1000
//                                ToolTip.timeout: 2000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: "%00: Minimum\n%01: Minimum temperature compensation mode.\n%10: Medium temperature compensation mode.\n%11: Maximum\nIn temperature compensated mode (tc), the MOSFET gate\ndriver strength is increased if the overtemperature\nwarning temperature is reached. This compensates for\ntemperature dependency of high-side slope control."

                                    onValueModified: {            // remove the focus from this control
                                        parent.forceActiveFocus()
                                        parent.focus = true
                                    }
                                }

                            Switch2 {
                                id: slphonOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
                                        if (slphSetSpin.value != root.savedSlphValue) {
                                            root.savedSlphValue = slphSetSpin.value
                                        }
                                    }
                                    else {
                                        slphSetSpin.value = root.savedSlphValue
                                    }
                                }

                                Binding {
                                    target: slphonOffSwitch
                                    property: "down"
                                    value: slphSetSpin.value  != root.defSlphValue
                                }
                            }
                        }

                        RowLayout {// set slpl values

                            id: slplcontrol
                            visible: true

                            Label {
                                id: slplLabel
                                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                font.bold: true
                                text: "Slope ctrl, low"
                            }

                            HalSpinBox2 {
                                id: slplSetSpin
                                enabled: true
                                name: "slpl.set"
                                halPin.direction: HalPin.IO
                                from: 0
                                to:3
        //                                 font.pixelSize: 30
        //                                 scale: 0.5
                                ToolTip.delay: 1000
//                                ToolTip.timeout: 2000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: "%00: Minimum.\n%01: Minimum.\n%10: Medium.\n%11: Maximum."

                                    onValueModified: {            // remove the focus from this control
                                        parent.forceActiveFocus()
                                        parent.focus = true
                                    }
                                }

                            Switch2 {
                                id: slplonOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
                                        if (slplSetSpin.value != root.savedSlplValue) {
                                            root.savedSlplValue = slplSetSpin.value
                                        }
                                    }
                                    else {
                                        slplSetSpin.value = root.savedSlplValue
                                    }
                                }

                                Binding {
                                    target: slplonOffSwitch
                                    property: "down"
                                    value: slplSetSpin.value  != root.defSlplValue
                                }
                            }
                        }

                        RowLayout {// set diss2g bit

                            id: diss2gcontrol
                            visible: true

                            Switch2 {
                                id: diss2gonOffSwitch
                                enabled: true
                                display: AbstractButton.TextBesideIcon
                                text: diss2gSetPin.value  > 0 ? "Short to GND protection disabled" : "Short to GND protection enabled"
    //                                    text: qsTr("Fast decay mode")
                                font.bold: true
                                ToolTip.delay: 1000
//                                ToolTip.timeout: 2000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("0: Short to GND protection is enabled.\n1: Short to GND protection is disabled.")

                                onCheckedChanged: {
                                    if (checked) {
                                            diss2gSetPin.value = 1
                                            diss2gonOffSwitch.text = "Short to GND protection disabled"
                                    }
                                    else {
                                        diss2gSetPin.value = 0
                                        diss2gonOffSwitch.text = "Short to GND protection rnabled"
                                    }
                                }

                                Binding {
                                    target: diss2gonOffSwitch
                                    property: "down"
                                    value: diss2gSetPin.value != root.defDiss2gValue
                                }
                            }
                        }

                        RowLayout {// set ts2g values

                            id: ts2gcontrol
                            visible: true

                            Label {
                                id: ts2gValsetPreLabel
                                font.bold: true
                                text: "GND short tmr"
                            }

                            HalSpinBox2 {
                                id: ts2gSetSpin
//                                property double defTs2g

                                enabled: true
                                name: "ts2g.set"
                                halPin.direction: HalPin.IO
                                from: 0//items.length - 1
                                to: items.length - 1
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("Short to GND\ndetection timer:\n%00: 3.2μs.\n%01: 1.6μs.\n%10: 1.2μs.\n%11: 0.8μs.")
    //                                 font.pixelSize: 30
    //                                 scale: 0.5

                                property var items: ["3.2", "1.6", "1.2", "0.8"]

                                validator: RegExpValidator {
                                    regExp: new RegExp("(3.2|1.6|1.2|0.8)")
                                }

                                textFromValue: function(value) {
                                    return items[value];
                                }

                                valueFromText: function(text) {
                                    for (var i = 0; i < items.length; ++i) {
                                        if (items[i].toLowerCase().indexOf(text.toLowerCase()) === 0)
                                            return i
                                    }
                                    return ts2gSetSpin.value
                                }
                            }

                            Label {
                                id: ts2gValsetLabel
                                font.bold: true
                                text: "μs"
                            }

                            Switch2 {
                                id: ts2gonOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
                                        if (ts2gSetSpin.value != root.savedTs2gValue) {
                                            root.savedTs2gValue = ts2gSetSpin.value
                                        }
                                    }
                                    else {
                                        ts2gSetSpin.value = root.savedTs2gValue
                                    }
                                }
                                 Binding {
                                     target: ts2gonOffSwitch
                                     property: "down"
                                     value: ts2gSetSpin.value  != root.defTs2gValue
                                 }
                            }

                        }

                        RowLayout {// set sdoff bit

                            id: sdoffcontrol
                            visible: true

                            Switch2 {
                                id: sdoffonOffSwitch
                                enabled: true
                                display: AbstractButton.TextBesideIcon
                                text: sdoffSetPin.value  > 0 ? "STEP/DIR interface disabled" : "STEP/DIR interface enabled"
    //                                    text: qsTr("Fast decay mode")
                                font.bold: true
                                ToolTip.delay: 1000
//                                ToolTip.timeout: 2000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("0: Enable STEP and DIR interface.\n1: Disable STEP and DIR interface. SPI interface is used\nto move motor.")

                                onCheckedChanged: {
                                    if (checked) {
                                            sdoffSetPin.value = 1
                                            sdoffonOffSwitch.text = "STEP/DIR interface disabled"
                                    }
                                    else {
                                        tstSetPin.value = 0
                                        sdoffonOffSwitch.text = "STEP/DIR interface enabled"
                                    }
                                }

                                Binding {
                                    target: sdoffonOffSwitch
                                    property: "down"
                                    value: sdoffSetPin.value  != root.defSdoffValue
                                }
                            }
                        }

                        RowLayout {// set vsense bit

                            id: vsensecontrol
                            visible: true

                            Switch2 {
                                id: vsenseonOffSwitch
                                enabled: true
                                display: AbstractButton.TextBesideIcon
                                text: vsenseSetPin.value  > 0 ? "Sense resistor voltage is 165mV." : "Sense resistor voltage is 305mV."
    //                                    text: qsTr("Fast decay mode")
                                font.bold: true
                                ToolTip.delay: 1000
//                                ToolTip.timeout: 2000
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("Sense resistor voltage-based current scaling:\n0: Full-scale sense resistor voltage is 305mV.\n1: Full-scale sense resistor voltage is 165mV.\n(Full-scale refers to a current setting of 31 and a DAC\nvalue of 255.)")

                                onCheckedChanged: {
                                    if (checked) {
                                            vsenseSetPin.value = 1
                                            vsenseonOffSwitch.text = "Sense resistor voltage is 165mV."
                                    }
                                    else {
                                        vsenseSetPin.value = 0
                                        vsenseonOffSwitch.text = "Sense resistor voltage is 305mV."
                                    }
                                }

                                Binding {
                                    target: vsenseonOffSwitch
                                    property: "down"
                                    value: vsenseSetPin.value  != root.defVsenseValue
                                }
                            }
                        }

                        RowLayout {// set rdsel values

                            id: rdselcontrol
                            visible: true

                            Label {
                                id: rdselValsetPreLabel
                                font.bold: true
                                text: "RD bits"
                            }

                            HalSpinBox2 {
                                id: rdselSetSpin
//                                property double defRdsel

                                enabled: true
                                name: "rdsel.set"
                                halPin.direction: HalPin.IO
                                from: 0//items.length - 1
                                to: items.length - 2
                                hoverEnabled: true
                                ToolTip.visible: hovered

                                ToolTip.text: qsTr("%00 Microstep position read back\n%01 stallGuard2 level read back\n%10\nstallGuard2 and coolStep current level read back\n%11 Reserved, do not use")
    //                                 font.pixelSize: 30
    //                                 scale: 0.5

                                property var items: ["Microstep position read back", "SG2 level read back", "SG2 and coolStep current level read back", "Na"]

                                validator: RegExpValidator {
                                    regExp: new RegExp("(Microstep position read back|SG2 level read back|SG2 and coolStep current level read back|8)|Na")
                                }

                                textFromValue: function(value) {
                                    return items[value];
                                }

                                valueFromText: function(text) {
                                    for (var i = 0; i < items.length; ++i) {
                                        if (items[i].toLowerCase().indexOf(text.toLowerCase()) === 0)
                                            return i
                                    }
                                    return rdselSetSpin.value
                                }
                            }

                            Switch2 {
                                id: rdselonOffSwitch
                                enabled: true
                                onCheckedChanged: {
                                    if (checked) {
                                        if (rdselSetSpin.value != root.savedRdselValue) {
                                            root.savedRdselValue = rdselSetSpin.value
                                        }
                                    }
                                    else {
                                        rdselSetSpin.value = root.savedRdselValue
                                    }
                                }
                                 Binding {
                                     target: rdselonOffSwitch
                                     property: "down"
                                     value: rdselSetSpin.value  != root.defRdselValue
                                 }
                            }

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










