@import "../../styles/base.scss";

.badge {
    font-size: 12px;
    line-height: 12px;
    padding-right: 0;
    border-radius: 3px;
    background-color: #e8edf1;
    color: $fc-accent-color;
    background-color: transparent;
    font-weight: normal;
}

.title {
    font-size: 16px;
    margin: 0 0 0 5px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.full-width {
    width: 100%;
}

.sort-width {
    width: 50%;
}

.active {
    border-left-color: $fc-accent-color;
}

.process-container{
    height: 100%;
    padding: 5px;
}

.process-list {
    background: white;
    height: calc(100% - 65px);
    border-right: solid 1px #ccc;
}

.list{
    overflow: auto;
}

.list-item {
    cursor: pointer;
    margin: 2px 6px 2px 4px;
    border-left: 4px solid #e8edf1;
    padding: 5px 5px 5px 5px;
    border-bottom: 1px solid #f5f5f5;
}

.list-item:hover{
    border-left-color: #d8dde1;
    background-color: #e8edf1;
}
.list-item.active {
    border-left-color: $fc-accent-color;
    background-color: #e8edf1;
}

.proc-inst-list {
    width: 100%;
    height: 100%;
}

.process-list-header {
    top: 0;
    left: 0;
    right: 0;
    padding: 0 5px 5px 5px;
    background-color: #ffffff;
    border-bottom: 1px solid #cccccc;
    box-shadow: 0px 1px 1px 0px rgba(220, 220, 220, 0.65);
    z-index: 1;
}

.summary {
    padding: 0 1.5rem 1rem;
    background: #f5f5f5;
}

.state-selection {
    overflow: hidden;
    clear: both;
    padding: 0;
    position: relative;
    margin: 0;
    border: 1px solid #cccccc;
    -moz-box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
    -webkit-box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
    box-shadow: inset 0 1px 1px rgba(0,0,0,.075);
    background-color: #ffffff;
    font-size: 14px;
    cursor: pointer;
}

.state-selection > .active .state-btn {
    background-color: #ffffff;
    color: #1a1a1a;
    box-shadow: none;
}

.state-selection .toggle-3 .state-btn {
    border: none;
    border-right: 1px solid #bbbbbb;
    width: 100%;
    border-radius: 0px;
}

.state-selection .toggle-3 {
    width: 33.333%;
    float: left;
}

.nothing-to-see {
    text-align: center;
    padding: 50px 20px;
}

.accent-button{
    background-color: #2980b9;
    color: #ffffff;
    line-height: 30px;
    padding: 0 10px;
    font-weight: normal;
    font-size: 12px;
}

.filter-text {
    display: inline-block;
    width: calc(100% - 85px);
    position: relative;
    top: 5px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.filter-icon-expand,
.filter-icon-collapse {
    display: block;
    text-align: right;
}

.filter-icon-expand span,
.filter-icon-collapse span {
    cursor: pointer;
}

.filter-icon-expand i,
.filter-icon-collapse i {
    position: relative;
    top: 5px;
    font-size: 18px;
    margin-bottom: 10px;
}

.filter-icon-collapse {
    display: block;
    padding-right: 5px;
    background: #f5f5f5;
}

.sort-value-block{
    padding: 1rem .75rem 0 .75rem;
}
.sort-value {
    float: left;
    width: 50%;
}
.create-process{
    float: right;
    width: 50%;
    text-align: right;
}
.create-process button{
    margin-top: 3px;
}

.process-details-wrap{
    height: calc(100% - 65px); //without button
}

.process-details-wrap-small {
    height: calc(100% - 100px); // with button
}

.back-to-list {
    margin-bottom: 7px;
}