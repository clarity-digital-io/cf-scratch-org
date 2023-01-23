import { LightningElement, api } from 'lwc';
import generateData from './generateData';

const columns2 = [
    { label: 'Label', fieldName: 'name' },
    { label: 'Website', fieldName: 'website', type: 'url' },
    { label: 'Phone', fieldName: 'phone', type: 'phone' },
    { label: 'Balance', fieldName: 'amount', type: 'currency' },
    { label: 'CloseAt', fieldName: 'closeAt', type: 'date' },
];

const columns = [
  { label: 'Active', fieldName: '' },
  { label: 'Version', fieldName: '' },
  { label: 'Last Updated', fieldName: '' },
  { label: 'Edit', fieldName: '' },
]

export default class FormResponseView extends LightningElement {
  data = [];
  columns = columns;

  @api recordId;

  connectedCallback() {
    const data = generateData({ amountOfRecords: 100 });
    this.data = data;
}
}