import { Component, OnInit } from '@angular/core';
import { EmailTemplateService } from './email-template.service';
import { MailTemplateService } from './mail-template.service';
import {EmailVariableService} from './email-variable/email-variable.service';

import {
    IPDefaultEmail,  Structure,  TextBlock,  ImageBlock
} from  '../classes';
import {  IpEmailBuilderService} from  '../ip-email-builder.service';
//'ip-email-builder';
import { BehaviorSubject } from 'rxjs';
import { ActivatedRoute,Router} from "@angular/router";
import { IEmailTemplate } from './iemail-template';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatSnackBar } from '@angular/material';
import { TranslateService } from '@ngx-translate/core';

@Component({
  selector: 'email-template-editor',
  templateUrl: './template-editor.component.html',
  styleUrls: ['./template-editor.component.scss']
})
export class TemplateEditorComponent implements OnInit {
  isLoading: BehaviorSubject<boolean>;
  emailTemplate?:IEmailTemplate;
  errorMessage = '';
  formGroup: FormGroup;
  editorView:boolean=false;
  constructor(
    private _ngb: IpEmailBuilderService,
    private route: ActivatedRoute,
    private router: Router,
    private snackBar: MatSnackBar,
    private emailtemplateService:EmailTemplateService,
    private mailtemplateService:MailTemplateService,
    private emailVariableService: EmailVariableService,
    private formBuilder: FormBuilder,
		private translate: TranslateService
    ) {
    this.isLoading = _ngb.isLoading;
    _ngb.MergeTags = new Set(["tag22"]) ; //new Set(['{{firstName}}', '{{lastName}}']);
  }

  sendTestMail() {
    const to = prompt(this.translate.instant('EMAIL-EDITOR.MESSAGES.SELECT-RECEIVER-PROMPT'));
    if (!to) {
      return;
    }
   // this._ngb.sendTestEmail({ to });

    this.loadEmailTemplate();
    this.emailTemplate.to = to;
    //this.emailTemplate.contentJson = template;
    this.mailtemplateService.create(this.emailTemplate)
    .subscribe(
        data => {                  
        //  x = data;
        //   y = JSON.parse(x.contentJson);
           //this.emailTemplate = {...this.emailTemplate,...data};
           var snackBarRef = this.snackBar.open(this.translate.instant('EMAIL-EDITOR.MESSAGES.EMAIL-SENT-SUCCESS'), this.translate.instant('EMAIL-GENERAL.ACTIONS.OK') , { duration:1000, panelClass:['snackbar-background'] });
          
         //  snackBarRef.dismiss();
           // this._ngb.sendRequest();
            //this.onBack();
        },
        error => {
           
           
        });
  }
 looadEmail (structures:any){
  this._ngb.Email = new IPDefaultEmail(structures);
 }
  ngOnInit() {
    const param = this.route.snapshot.paramMap.get('id');
   
    this.emailVariableService.getAll(null,0,20).subscribe(
      items => {
        let tags = items.map(item=> item.propertyName);
        this._ngb.MergeTags=new Set(tags);
      },
      error => this.errorMessage = <any>error
    );
    this.formGroup = this.formBuilder.group({
      id:[''],
      templateName: ['', Validators.required],
      category: ['',Validators.required],
      subject: ['', Validators.required],
      to: ['', Validators.required],
      attachmentpath:[''],
      active:[true, Validators.required]    
        
     });
 if(param) {
  const id = +param;
  this.getEmailTemplate(id);
  this.editorView = true;
 }
 else {
 // const id = +param;
 //this.getEmailTemplate(id);
 this.emailTemplate= {} as IEmailTemplate;
 
    this._ngb.Email = new IPDefaultEmail({
      structures: [
        new Structure('cols_1', [
          [
            new TextBlock(
              `<p class="ql-align-center">${this.translate.instant('EMAIL-EDITOR.MESSAGES.SAMPLE-TEMPLATE')}</p>`,
              {
                lineHeight: {
                  value: 22,
                  unit: 'px'
                }
              }
            ),
            new TextBlock(
              `<h2 class="ql-align-center">${this.translate.instant('EMAIL-EDITOR.MESSAGES.SAMPLE-TEMPLATE2')}</h2>`
            ),
            new ImageBlock(
              'https://image.ibb.co/iXV3S9/Screen_Shot_2018_09_14_at_17_15_38.png'
            )
          ]
        ])
      ]
    });
  }
 
  }
  getEmailTemplate(id: number) {
    this.emailtemplateService.getById(id).subscribe(
      templ => {
        this.emailTemplate = templ;
        this.formGroup.patchValue({
          id:templ.id,
          templateName:templ.templateName,
          subject:templ.subject,
          to:templ.to,
          contentJson:templ.contentJson,
          contentHtml:templ.contentHtml,
          category: templ.category
        
        });
        this.looadEmail(JSON.parse(templ.contentJson));
       
      },
      error => this.errorMessage = <any>error);
  }
  
  saveEmail = ()=>{
    if (!this._ngb.IsChanged ){
      this._ngb.notify(this.translate.instant('EMAIL-EDITOR.MESSAGES.NO-CHANGES'));
     // return Promise.reject(`There's no changes to be saved`);
    } else {
      // this.generatingTemplate = true;
      //await this._ngb.sendRequest();
      if (this.formGroup.invalid) {
        return;
    }
      if(!this.editorView)
      {
        this.editorView=true;
      }
      else
       this.onEmailTemplateSave(JSON.stringify(this._ngb.Email));
      // this.generatingTemplate = false;
    }
  }
  loadEmailTemplate = ()=>{
    this.emailTemplate.templateName = this.formGroup.value.templateName;
    this.emailTemplate.category = this.formGroup.value.category;
    this.emailTemplate.to = this.formGroup.value.to;
    this.emailTemplate.subject = this.formGroup.value.subject;
    this.emailTemplate.contentHtml="";
    this.emailTemplate.contentJson = JSON.stringify(this._ngb.Email);
  }
  onEmailTemplateSave = (template) => {
    let x = template;
    let y = JSON.parse(x);
    this.emailTemplate.templateName = this.formGroup.value.templateName;
    this.emailTemplate.category = this.formGroup.value.category;
    this.emailTemplate.to = this.formGroup.value.to;
    this.emailTemplate.subject = this.formGroup.value.subject;
    this.emailTemplate.contentHtml="";
    this.emailTemplate.contentJson = template;
   
    if(!this.emailTemplate.id){
      /*this.emailTemplate.subject="subject";
      this.emailTemplate.category="category";
      this.emailTemplate.contentHtml="";
      this.emailTemplate.templateName="usertemplate";
      this.emailTemplate.to="gzadik@yahoo.com";
      this.emailTemplate.contentJson = template;*/
      this.emailtemplateService.create(this.emailTemplate)
      .subscribe(
          data => {                  
            x = data;
             y = JSON.parse(x.contentJson);
             this.emailTemplate = {...this.emailTemplate,...data};
              this._ngb.sendRequest();
              this.onBack();
          },
          error => {
             
             
          });
    }
    else {
   
    this.emailtemplateService.update(this.emailTemplate, this.emailTemplate.id)
    .subscribe(
        data => {                  
          x = data;
           y = JSON.parse(x.contentJson);
           this._ngb.sendRequest();
           this.onBack();
        },
        error => {
           
           
        });
      }
}
onBack(): void {
  this.router.navigate(['./emailtemplates'],{ relativeTo: this.route.parent });
}
}
