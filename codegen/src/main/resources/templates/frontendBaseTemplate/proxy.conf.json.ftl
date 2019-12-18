{ 
    "/api": { 
      "target": "https://localhost:5555", 
      "secure": false,       
      "pathRewrite": { 
        "^/api": "" 
      }, 
      "changeOrigin":true 
    }<#if FlowableModule!false>,
    "/modeler": { 
      "target": "http://localhost:8080/flowable-modeler",
      "pathRewrite": {
        "^/modeler": ""
      },
      "secure": false,
      "changeOrigin":true 
    }
    </#if>
}