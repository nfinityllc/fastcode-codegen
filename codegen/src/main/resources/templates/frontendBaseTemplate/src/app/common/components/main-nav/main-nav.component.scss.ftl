.sidenav-container {
  height: 100%;
}

.sidenav {
  width: 200px;
  box-shadow: 3px 0 6px rgba(0,0,0,.24);
  .sidenav-list-item {
    box-shadow: 0 0px 0px 0px rgba(0,0,0,.2) !important;
  }
  .expansion-panel{
    box-shadow: 0 0 0 0;
    border-bottom: 1px solid rgba(0, 0, 0, 0.1);
    border-top: 1px solid rgba(0, 0, 0, 0.1);
    .radio-group {
      display: inline-flex;
      flex-direction: column;
    }
    
    .radio-button {
      margin: 5px;
    }
      
  
  }
  .subnav {
    //margin-left: 8px;
    list-style-type: none;
    padding-top: 0 !important;
  }
  .subnav-header {
    height:36px !important;
    padding: 0 24px 0 16px;
  }
  .mat-sub-list-item {
    height: 26px;
    font-size: 13px;
   // box-shadow: 3px 0 6px rgba(0,0,0,.24) ;
  }
}

.mat-toolbar.mat-primary {
  position: sticky;
  top: 0;
}
.fc-sidenav-content{
  overflow: visible !important;
}
.fc-tool-bar{    
  //height:$fc-row-height5;
  justify-content: space-between;
  .middle{
      //flex: 1 1 auto;
  }
 
}
.fc-bottom-nav {
  position: fixed;
  bottom: 0;
  //background-color: $primary;
}
