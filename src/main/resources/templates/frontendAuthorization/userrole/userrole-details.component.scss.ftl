@import "src/styles/base.scss";

.action-tool-bar {
    background-color: $fc-primary-color-light !important;
    height: $fc-row-height5;
    justify-content: space-between;

    .middle {
        //flex: 1 1 auto;
   
    }
}

.item-form {
    display: flex;
    flex-direction: column;
}

.card{
    height: calc(100% - 137px);
    overflow: auto;
}

.association-div {
    display: inline-block;
    margin-right: 10px;
    margin-bottom: 10px,
}