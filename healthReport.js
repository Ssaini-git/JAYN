import { LightningElement,api,track,wire } from 'lwc';
import createField from '@salesforce/apex/CreateDynamicFields.createField';
import checkHealthReportFields from '@salesforce/apex/CreateDynamicFields.checkHealthReportFields';
import getObjectRecords from '@salesforce/apex/CreateDynamicFields.getRecordsDetails';
import getFieldsPermissions from '@salesforce/apex/CreateDynamicFields.givePermissions';

export default class HealthReport extends LightningElement {
    @api objectApiName;
    @api oapiname;
		@api recordId; //replace account Id with your org account Id
    @api recordid;
		@track HScore;
		@track LUpdated;
		@track Recommen;
    @track performance;
		@wire (getObjectRecords,{ recordId: '$recordid', ObjectS: '$oapiname' })
		wiredAccounts({data,error}){
     // alert(JSON.stringify(data));
				if (data) {
						this.HScore = data.HealthScore;
            if(this.HScore >= 70){
               this.template.querySelector('[data-id="perform"]').textContent = 'Excellent';
               this.template.querySelector('[data-id="hScoreClr"]').style.backgroundColor = 'Green';
            }
            else if(this.HScore >= 50 && this.HScore < 70){
              this.template.querySelector('[data-id="perform"]').textContent = 'Good';
               this.template.querySelector('[data-id="hScoreClr"]').style.backgroundColor = 'Yellow';
            }
            else if(this.HScore  < 50){
              this.template.querySelector('[data-id="perform"]').textContent = 'Poor';
               this.template.querySelector('[data-id="hScoreClr"]').style.backgroundColor = 'red';
            }

						this.LUpdated = data.LastUpdated;
						this.Recommen = data.Recommend;
				} else if (error) {
						console.log(error);
				}
		}
		
    connectedCallback(){
      // alert('@@='+this.recordid);
        checkHealthReportFields({sObjectName: this.oapiname})
        .then(result=>{
            if(!result){
              // alert('trie',JSON.stringify(result));
              this.createCustomfields();
            }
        })
        .catch(error=>{
            this.createCustomfields()
        })
      
    }
    createCustomfields(){
        createField({sObjectName: this.oapiname})
        .then(result =>{
           this.CreateFieldsPermissions();
        })
        .catch(error=>{
          //  alert('@@erro');
        })
    }
		CreateFieldsPermissions(){
			//	 alert('Run==>');
      getFieldsPermissions({sObjectName: this.oapiname})
        .then(result =>{
          console.log('result'+result);
           // alert(JSON.stringify(result));
        })
        .catch(error=>{
          //  alert('@@erro');
        })
    }
}