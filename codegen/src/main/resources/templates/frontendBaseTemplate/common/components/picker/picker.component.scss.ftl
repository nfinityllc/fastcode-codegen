@import 'src/styles/base.scss';
.container {
    height: '400px';
    width: '600px';
}
.action-tool-bar {    
    height:$fc-row-height5;
    justify-content: space-between;
    .middle{
        //flex: 1 1 auto;
        font-size: 1rem
    }
    .left {
        min-width: $fc-row-height5 !important;
        padding:0 !important;
    }
    .right {
        min-width: $fc-row-height5 !important;
        padding:0 !important;
    }
  }
  .user-form {
    display: flex;
  flex-direction: column;
  }
  