import { LightningElement, api } from 'lwc';
import EMPTY from '@salesforce/resourceUrl/empty';
import BOOKAPPT from '@salesforce/apex/RestaurantFinder.createEvent';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'

export default class BookAppointment extends LightningElement {

    @api lat;   
    @api lon;
    @api name;
    @api contactId;

    emptyURL = EMPTY;

    selectedDateTime;
    duration;

    handleChange(event){
      const targetName=event.target.name;
      if(event.target.name==='appointmentStart'){
          this.selectedDateTime = event.target.value;

      }
      if(event.target.name==='duration'){
         this.duration=event.target.value;
      }

    }

    get mapMarkers(){
        return   [{
            location: {
                'Latitude': this.lat,
                'Longitude': this.lon
            }
        }]
    }

    

    get showMap(){
        return (this.lat!=null && this.lon!=null)? true:false;
    }

    handleClick(){
      BOOKAPPT({duration:this.duration,
                      dt:this.selectedDateTime,
                      contactId:this.contactId,
                      rName:this.name
                    })
         .then(result => {
             this.dispatchEvent(new ShowToastEvent({
                 title: 'Appointment Booked',
                 message: 'Succesfully Booked',
                 variant: 'success'
             }));
         })
         .catch(error => {
             this.dispatchEvent(new ShowToastEvent({
                 title: 'Error',
                 message: 'Error Occured',
                 variant: 'error'
             }));
         });
    }

    

}