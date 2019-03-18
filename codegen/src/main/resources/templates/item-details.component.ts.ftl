import { Component, OnInit } from '@angular/core';
import { ${ClassName}Service } from './${ModuleName}.service';
import { ${IEntity} } from './${IEntityFile}';
import {BaseDetailsComponent} from '../base/base-details.component';
import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';

@Component({
  selector: 'app-${ModuleName}-details',
  templateUrl: './${ModuleName}-details.component.html',
  styleUrls: ['./${ModuleName}-details.component.scss']
})
export class ${ClassName}DetailsComponent extends BaseDetailsComponent<${IEntity}> implements OnInit {
  title:string='${ClassName}';
  parentUrl:string='${ApiPath}s';
  //roles: IRole[];  
  constructor(public formBuilder: FormBuilder,public route: ActivatedRoute,
    public router: Router,
    public dataService: ${ClassName}Service) {
      super(formBuilder,route,router,dataService)
  }

  ngOnInit() {
  //  const param = this.route.snapshot.paramMap.get('id');
  super.ngOnInit();
  
    this.itemForm = this.formBuilder.group({
       <#list Fields as key,value>
            <#if value.fieldName?lower_case == "id">              
                ${value.fieldName}: [],
            <#elseif value.fieldType == "Date">              
                ${value.fieldName}: ['', Validators.required],
            <#elseif value.fieldType == "boolean">              
                ${value.fieldName}: [false, Validators.required],
            <#else>              
                ${value.fieldName}: ['', Validators.required],
            </#if> 
      </#list>    
        
     });
     //this.getRoles();
    if (this.idParam) {
      const id = +this.idParam;
      this.getItem(id).subscribe(x=>this.onItemFetched(x),error => this.errorMessage = <any>error);
    }
  }

  onItemFetched(item:${IEntity}) {
   
        this.item = item;
        this.itemForm.patchValue({
         <#list Fields as key,value>
   
          ${value.fieldName}:item.${value.fieldName},
           
        </#list>    
  
        });
     
     
  }
  
  
}
