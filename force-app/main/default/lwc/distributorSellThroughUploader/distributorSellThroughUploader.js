import { LightningElement, api } from "lwc";
import { loadScript } from "lightning/platformResourceLoader";
import LightningAlert from "lightning/alert";
import PARSER from "@salesforce/resourceUrl/papaparse";
import getCsvMapping from "@salesforce/apex/DistributorCsvUploaderController.getCsvMapping";
import createSellThroughReportImports from "@salesforce/apex/DistributorCsvUploaderController.createSellThroughReportImports";
import createStockReportImports from "@salesforce/apex/DistributorCsvUploaderController.createStockReportImports";
import getUserInfo from "@salesforce/apex/DistributorCsvUploaderController.getUserInfo";
import getMappingLabel2ObjectName from "@salesforce/apex/DistributorCsvUploaderController.getMappingLabel2ObjectName";

export default class distributorSellThroughUploader extends LightningElement {
    parserInitialized = false;
    isLoading = true;
    isUploading = false;
    isUploaded = false;

    userinfo = {};
    mappingLabel2ObjectName = {};
    selectedCurrency = "USD";
    selectedMappingLabel = "";
    selectedMappingObject = "";
    selectedMapping = {};

    csvPreColumnUnmatched = {};
    csvFile = {};
    csvRows = [];
    lineNum2Error = {};

    get mappingLabelOptions() {
        return Object.keys(this.mappingLabel2ObjectName).map((key) => {
            return { label: key, value: key };
        });
    }

    get mappingObjectOptions() {
        return (
            this.mappingLabel2ObjectName[this.selectedMappingLabel]?.map((key) => {
                return { label: key, value: key };
            }) || []
        );
    }

    get currencyOptions() {
        return ["ATS", "AUD", "BGN", "CHF", "CZK", "DEM", "EUR", "FIM", "FRF", "GBP", "ITL", "JPY", "NLG", "NOK", "RON", "RUB", "TWD", "USD"].map((key) => {
            return { label: key, value: key };
        });
    }

    get csvPreviewRows() {
        return this.csvRows.slice(0, 5);
    }

    get csvPreviewColumns() {
        return Object.keys(this.selectedMapping).map((header) => {
            return { label: header, fieldName: this.selectedMapping[header].split(",")[0] };
        });
    }

    get hasUploadError() {
        return Object.keys(this.lineNum2Error).length > 0;
    }

    async connectedCallback() {
        this.isLoading = true;
        this.userinfo = await getUserInfo();
        this.mappingLabel2ObjectName = await getMappingLabel2ObjectName();

        switch (this.userinfo?.Region__c) {
            case "VSE":
                this.selectedCurrency = "EUR";
            default:
                this.selectedCurrency = "USD";
        }

        let mappingLabels = Object.keys(this.mappingLabel2ObjectName);
        if (mappingLabels.length > 0) {
            this.selectedMappingLabel = mappingLabels[0];
            this.selectedMappingObject = this.mappingLabel2ObjectName[mappingLabels[0]][0];
            await this.refreshCsvMapping();
        }
        this.isLoading = false;
    }

    chooseCurrency(event) {
        this.selectedCurrency = event.detail.value;
    }

    chooseOverrideDate(event) {
        this.selectedDate = event.detail.value;
        this.initCsvFile();
    }

    async chooseMappingLabel(event) {
        this.isLoading = true;
        this.selectedMappingLabel = event.detail.value;
        this.selectedMappingObject = this.mappingLabel2ObjectName[this.selectedMappingLabel][0];
        await this.refreshCsvMapping();
        this.isLoading = false;
    }

    async chooseMappingObject(event) {
        this.isLoading = true;
        this.selectedMappingObject = event.detail.value;
        await this.refreshCsvMapping();
        this.isLoading = false;
    }

    async refreshCsvMapping() {
        this.selectedMapping = await getCsvMapping({ mappingLabel: this.selectedMappingLabel, mappingObject: this.selectedMappingObject });
    }

    handleFilesChange(event) {
        this.resetUploader();
        if (this.csvPreviewColumns.length === 0) {
            this.showError("Contact Administrator", "Oops! No pre-defined csv header found! Please contact system administrator.");
        } else if (event.target.files.length > 0) {
            let selectedFile = event.target.files[0];
            if (selectedFile.type !== "text/csv") {
                this.showError("Invalid File Type", "Invalid file type. Please choose a csv file!");
            } else if (selectedFile.size >= 2000000) {
                this.showError("Large File Forbidden", "Invalid file type. Please choose a csv file!");
            } else {
                this.csvFile = selectedFile;
                this.initCsvFile();
            }
        }
    }

    initCsvFile() {
        if(!this.csvFile.name) return;
        this.csvPreColumnUnmatched = JSON.parse(JSON.stringify(this.selectedMapping));
        Papa.parse(this.csvFile, {
            header: true,
            skipEmptyLines: true,
            dynamicTyping: false,
            transformHeader: (header) => {
                let matchedCol = this.csvPreviewColumns.find((col) => {
                    return col.label.toLowerCase().trim() === header.toLowerCase().trim();
                });
                if (matchedCol) {
                    delete this.csvPreColumnUnmatched[matchedCol.label];
                    return matchedCol.fieldName;
                } else {
                    return undefined;
                }
            },
            transform: (val, header) => {
                let fields = Object.values(this.selectedMapping).filter((field) => field.startsWith(header));
                if (fields.length > 0) {
                    let fieldType = fields[0].split(",")[1];
                    if (fieldType === "DATE") {
                        if(this.selectedDate) return this.selectedDate;
                        
                        val = val + "";
                        let dateVal = new Date(val);
                        if (dateVal.toString() === "Invalid Date" && !isNaN(parseInt(val)) && val.length === 8) {
                            dateVal = new Date(val.substring(0, 4) + "/" + val.substring(4, 6) + "/" + val.substring(6, 8));
                        }
                        if (dateVal.toString() === "Invalid Date") return val;

                        let year = dateVal.getFullYear();
                        let month = `0${dateVal.getMonth() + 1}`.slice(-2);
                        let day = `0${dateVal.getDate()}`.slice(-2);
                        if (dateVal) val = `${year}-${month}-${day}`;
                    } else if (fieldType === "STRING") {
                        return val + "";
                    }
                }
                return val;
            },
            complete: this.handleCsvData.bind(this),
        });
    }

    handleCsvData(csvResults) {
        let unmatchedCols = Object.keys(this.csvPreColumnUnmatched);
        if (unmatchedCols.length > 0) {
            this.showError("Unmatched Columns", `The following columns are not matched: ${unmatchedCols.join(", ")}.`);
        } else if (csvResults.data.length > 0) {
            this.csvRows = csvResults.data.map((row) => {
                row.CurrencyIsoCode = this.selectedCurrency;
                delete row["undefined"];
                return row;
            });
        }
    }

    showError(title, message) {
        LightningAlert.open({ message: message, theme: "error", label: title });
    }
    showSuccess(title, message) {
        LightningAlert.open({ message: message, theme: "success", label: title });
    }

    resetUploader() {
        this.csvFile = {};
        this.csvRows = [];
        this.lineNum2Error = {};
        this.isUploaded = false;
    }

    async startLoad() {
        this.isUploading = true;
        try {
            let fileIdentifier = `${this.csvFile.name} ${new Date().toLocaleDateString()} - ${Date.now()}`;
            if (this.selectedMappingObject === "Sell_Through_Report_Import__c") {
                this.lineNum2Error = await createSellThroughReportImports({ fileIdentifier, mappingLabel: this.selectedMappingLabel, records: this.csvRows });
            } else if (this.selectedMappingObject === "Stock_Report_Import__c") {
                this.lineNum2Error = await createStockReportImports({ fileIdentifier, mappingLabel: this.selectedMappingLabel, records: this.csvRows });
            }

            if (Object.keys(this.lineNum2Error).length === 0) {
                this.showSuccess("Success", `Your csv data has been loaded successfully! Total loaded rows: ${this.csvRows.length}.`);
            }
            this.isUploaded = true;
        } catch (ex) {
            console.log(ex);
            if (ex.body.message == `Unable to read SObject's field value[s]`) {
                this.showError("Invalid Number Or Date Format", 'The number value must be integer and no separator. The date value must be formated like "yyyy-mm-dd".');
            } else {
                this.showError("Server Error", ex.body.message);
            }
        }
        this.isUploading = false;
    }

    downloadErrors() {
        let errors = Object.keys(this.lineNum2Error).map((num) => {
            return { index: num, ...this.csvRows[num], error: this.lineNum2Error[num] };
        });
        let csvContent = Papa.unparse(errors);
        const link = document.createElement("a");
        if (link.download !== undefined) {
            const url = URL.createObjectURL(new Blob([csvContent]));
            link.setAttribute("href", url);
            link.setAttribute("target", "_blank");
            link.setAttribute("download", this.csvFile.name);
            link.style.visibility = "hidden";
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
    }

    async renderedCallback() {
        if (this.parserInitialized) return;

        this.parserInitialized = true;
        loadScript(this, PARSER)
            .then(() => {
                console.log("papaparse loaded");
            })
            .catch((error) => {
                this.error = error;
            });
    }
}