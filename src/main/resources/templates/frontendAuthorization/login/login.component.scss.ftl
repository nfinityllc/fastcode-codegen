@import 'src/styles/base.scss';
.login-container {
    height: calc(100% - 60px);
    overflow: auto;
    display: flex;
    // justify-content: center;
    flex-direction: column;
    // align-items: center;
}
.action-tool-bar {    
    background-color: $fc-primary-color-light !important;
    height:$fc-row-height5;
    justify-content: space-between;
    .middle{
        //flex: 1 1 auto;
    }
   
  }
  .item-form {
    display: flex;
  flex-direction: column;
  }
  .item-card {
    width: 400px;
    margin: auto;
  }
  .item-form-container {
    margin: auto;
  }
  .item-action {
    display: flex;
    justify-content: flex-end;
  }