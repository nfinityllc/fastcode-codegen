@import 'src/styles/base.scss';
.container {
    height: '400px';
    width: '600px';
}
.action-tool-bar {    
    background-color: $fc-primary-color-light !important;
    height:$fc-row-height5;
    justify-content: space-between;
    .middle{
        //flex: 1 1 auto;
    }
   
  }
  .home-container{
    display: flex;
    justify-content: center;
    //flex-direction: column;
   // align-items: center;
  }
 .left {
  // width:180px;
  flex: 1 1 250px;
   margin: 24px;
 }
 .left-card{
   margin-bottom: 24px;
 }
 .welcome-row{
  display: flex;
  flex-direction: row;
  align-items: center;
 }
 .fc-icon{
  color:$fc-primary-color;  
  margin-right: 16px;
  font-size: 32px;
 }
  .item-form {
    display: flex;
  flex-direction: column;
  }
  .item-card {
    width: 400px;
    padding:16px;
  }
  .item-form-container {
    display: flex;
   // justify-content: center;
    flex-direction: column;
   // align-items: center;
    //height: 600px;
  }
  .item-action {
    display: flex;
  //  justify-content: flex-end;
  }

  




