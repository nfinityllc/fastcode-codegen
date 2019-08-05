@import "../../styles/base.scss";

.container {
    margin: $fc-margin3;
    height: calc(100% - 152px);
}

.action-tool-bar {
    height: $fc-row-height5;
    justify-content: space-between;

    .middle {
        //flex: 1 1 auto;
   
    }

    background-color: $fc-primary-color-light !important;
}

.full-width {
    width: 100%;
}

[hidden] {
    display: none;
}

.mat-table {
    overflow: auto;
    max-height: calc(100% - 135px);
}
