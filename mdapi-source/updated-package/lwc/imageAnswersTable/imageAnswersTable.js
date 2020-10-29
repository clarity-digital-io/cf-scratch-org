import LightningDatatable from 'lightning/datatable';
import imageTableControl from './imageTableControl.html';

export default class imageAnswersTable extends LightningDatatable  {
    static customTypes = {
        attachments: {
            template: imageTableControl
        }
    };
}