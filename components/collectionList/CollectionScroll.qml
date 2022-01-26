import QtQuick 2.15

Item {
    property int collectionCount: allCollections.length;
    property alias collectionListView: collectionListView;
    property bool startupMute: true;

    Component.onCompleted: {
        collectionListView.currentIndex = currentCollectionIndex;
        collectionListView.positionViewAtIndex(currentCollectionIndex, ListView.Center);

        backgroundColor.color = collectionColor(currentCollection.shortName);

        // prevent line 9 from triggering the sound effect
        startupMute = false;
    }

    // background color, fades when collection changes
    Rectangle {
        id: backgroundColor;

        width: parent.width;
        height: parent.height;
        color: collectionColor(currentCollection.shortName);

        Behavior on color {
            ColorAnimation {
                duration: 335;
                easing.type: Easing.InOutQuad;
            }
        }
    }

    // dots
    PageIndicator {
        currentIndex: collectionListView.currentIndex;
        pageCount: collectionCount;

        anchors {
            horizontalCenter: parent.horizontalCenter;
            bottom: parent.bottom;
            bottomMargin: 25;
        }
    }

    ListView {
        id: collectionListView;

        model: allCollections;
        delegate: lvCollectionDelegate;
        orientation: ListView.Horizontal;
        highlightRangeMode: ListView.StrictlyEnforceRange;
        preferredHighlightBegin: 0;
        preferredHighlightEnd: parent.width;
        snapMode: ListView.SnapToItem;
        highlightMoveDuration: 225;
        highlightMoveVelocity: -1;
        spacing: 50;
        anchors.fill: parent;

        onCurrentIndexChanged: {
            currentCollectionIndex = currentIndex;
            currentCollection = allCollections[currentIndex];

            backgroundColor.color = collectionColor(currentCollection.shortName);

            if (currentView === 'collectionList' && startupMute === false) sounds.nav();
        }
    }

    Component {
        id: lvCollectionDelegate;

        CollectionItem {
            width: collectionListView.width;
            height: collectionListView.height;
        }
    }
}
