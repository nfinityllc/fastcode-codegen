@import "src/styles/base.scss";

.container {
    margin: $fc-margin3;
}

.action-tool-bar {
    height: $fc-row-height5;
    justify-content: space-between;

    .middle {
        //flex: 1 1 auto;
   
    }

    background-color: $fc-primary-color-light !important;
}

table {
    width: 100%;
    overflow: auto;
}

.full-width {
    width: 100%;
}

@media (min-width: 1024px) {
    .mat-form-field {
        width: 33%;
    }
}

@media (max-width: 1024px) {
    .mat-form-field {
        width: 50%;
    }
}

.mat-menu-item-highlighted:not([disabled]),
.mat-menu-item.cdk-keyboard-focused:not([disabled]),
.mat-menu-item.cdk-program-focused:not([disabled]),
.mat-menu-item:hover:not([disabled]) {
    background: #fff;
}

.menu-title {
    font-weight: 300;
    font-size: 1.5rem;
}

.filter-form {
    display: flex;
}

.example-container {
    display: flex;
    flex-direction: column;
    height: 100%;
    min-width: 300px;
}

.mat-cell {
    word-break: break-all;
}

