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
import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import Machinekit.Controls 1.0
import Machinekit.Application 1.0
import Machinekit.HalRemote.Controls 1.0
import Machinekit.HalRemote 1.0
import Machinekit.Service 1.0
import Machinekit.Application.Controls 1.0
import "./Controls"
import "./ManualTab"
import "./StatusBar"

//HalApplicationWindow {
ServiceWindow {
    id: window
    property bool wasConnected: false

//    name: "TrinamicSPI"
//    title: qsTr("Trinamic SPI Test")
    title: applicationCore.applicationName + (d.machineName === "" ? "" :" - " +  d.machineName)

    statusBar:applicationStatusBar
    toolBar: applicationToolBar
//    menuBar: applicationMenuBar

    ColumnLayout {
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

//        property string labelName: "Gantry Configuration"

        visible: halRemoteComponent.ready || wasConnected
        enabled:  halRemoteComponent.connected

        HalRemoteComponent {
            id: halRemoteComponent
            halrcmdUri: halrcmdService.uri
            halrcompUri: halrcompService.uri
            ready: (halrcmdService.ready && halrcompService.ready) || connected
            name: "TrinamicSPI"
            containerItem: window
            create: false
            onErrorStringChanged: console.log(errorString)
            onConnectedChanged: window.wasConnected = true
        }

        ColumnLayout {
            id: transport
            ApplicationStatusBar { id: applicationStatusBar }
                //       ApplicationMenuBar { id: applicationMenuBar }

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
                }

                JogButton {
                    id: incrementButton
                    Layout.fillWidth: false
                    direction: 1
                    distance: jogCombo.distance
                    axis: axisRadioGroup.axis
                }

                JogDistanceComboBox {
                    id: jogCombo
                    Layout.fillWidth: true
                    axis: axisRadioGroup.axis
                }

//                 KeyboardJogControl {
//                     id: keyboardJogControl
//                     enabled: jogCombo.distance !== 0.0
//                     onSelectAxis: axisRadioGroup.axis = axis
//                     onIncrement: incrementButton._toggle(enabled)
//                     onDecrement: decrementButton._toggle(enabled)
//                     onSelectIncrement: {
//                         if (jogCombo.currentIndex == 0) {
//                             jogCombo.currentIndex = index;
//                         }
//                     }
//                }
            }

//            RowLayout {
//                Layout.fillWidth: true

////                Button {
////                    id: homeAllAxesButton
////                    Layout.fillWidth: false
////                    action: HomeAxisAction { id: homeAxisAction; axis: -1 }
////                    visible: homeAxisAction.homeAllAxesHelper.homingOrderDefined
////                }

////                Button {
////                    id: homeAxisButton
////                    Layout.fillWidth: false
////                    action: HomeAxisAction { axis: axisRadioGroup.axis }
////                    visible: !homeAllAxesButton.visible
////                }

////                Button {
////                    Layout.fillWidth: false
////                    action: TouchOffAction { touchOffDialog: touchOffDialog }
////                }

//                Item {
//                    Layout.fillWidth: true
//                }

////                TouchOffDialog {
////                    id: touchOffDialog
////                    axis: axisRadioGroup.axis
////                    height: window.height * 0.2
////                }
//            }

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
                    text: jogVelocitySlider.displayValue.toFixed(1) + " " + jogVelocitySlider.units
                }
            }

            JogVelocitySlider {
                id: jogVelocitySlider
                Layout.fillWidth: true
                axis: axisRadioGroup.axis
                proportional: true
            }
        }

        Label {
            Layout.fillWidth: true
            text: "This is for setting up Trinamic SPI parameters\n" +
                  "The Chart represents the output of SG threshold"
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }

        HalButton {
            Layout.alignment: Layout.Center
            name: "button0"
            text: "Button 0"
            checkable: true
        }

        HalButton {
            Layout.alignment: Layout.Center
            name: "button1"
            text: qsTr("Button 1")
        }

        HalLed {
            Layout.alignment: Layout.Center
            name: "led"
        }

        Label {
            Layout.fillWidth: true
            text: "The buttons are connected using the 'and2' component in HAL.\n" +
                  "The LED represents the output of the 'and2' component."
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }

        LogChart {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            name: logChart
            updateInterval: 1
            Layout.fillHeight: true
            autoUpdate: true
            autoSampling: true
            changeGraphScale: 1
            scrollZoomFactor: 1
            sampleInterval: 1
            minimumValue: -100
            Layout.maximumHeight: 512
            Layout.maximumWidth: 256
            gridColor: qsTr("#eeeeee")
            backgroundColor: qsTr("#ffffff")
            maximumValue: 100
//            value: 10
            targetValue: 0
        }

        Item {
            Layout.fillHeight: true
        }

    }

//     DisplayPanel {
//         id: displayPanel
//         anchors.right: parent.right
//         anchors.top: parent.top
//         anchors.bottom: applicationProgressBar.top
//         width: parent.width * 0.20
//         anchors.margins: Screen.pixelDensity
//     }
//
//     ApplicationProgressBar {
//         id: applicationProgressBar
//         anchors.right: parent.right
//         anchors.bottom: parent.bottom
//         width: displayPanel.width
//         anchors.margins: Screen.pixelDensity
//     }

    ApplicationNotifications {
        id: applicationNotifications
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.margins: Screen.pixelDensity
        messageWidth: parent.width * 0.25
    }
}










