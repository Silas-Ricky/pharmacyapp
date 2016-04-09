<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Pharmacy"]);

    ui.includeJavascript("pharmacyapp", "moment.js")
%>
<style>
input[type="text"],
input[type="password"],
select {
    border: 1px solid #aaa;
    border-radius: 0px !important;
    box-shadow: none !important;
    box-sizing: border-box !important;
    height: 38px !important;
    line-height: 18px !important;
    padding: 8px 10px !important;
    width: 100% !important;
}

input[type="text"]:focus, textarea:focus {
    outline: 2px solid #007fff !important;
}

textarea {
    width: 97%;
}

.append-to-value {
    color: #999;
    float: right;
    left: auto;
    margin-left: -50px;
    margin-top: 5px;
    padding-right: 10px;
    position: relative;
}

form h2 {
    margin: 10px 0 0;
    padding: 0 5px
}

.col1, .col2, .col3, .col4, .col5, .col6, .col7, .col8, .col9, .col10, .col11, .col12 {
    float: left;
}

form label, .form label {
    margin: 5px 0 0;
    padding: 0 5px
}

#datetime label {
    display: none;
}

.add-on {
    float: right;
    left: auto;
    margin-left: -29px;
    margin-top: 10px;
    position: absolute;
}

.dashboard .info-section {
    margin: 0 5px 5px;
}

.dashboard .info-body li {
    padding-bottom: 2px;
}

.dashboard .info-body li span {
    margin-right: 10px;
}

.dashboard .info-body li small {

}

.dashboard .info-body li div {
    width: 150px;
    display: inline-block;
}

.info-body ul li {
    display: none;
}

.simple-form-ui section.focused {
    width: 75%;
}

.new-patient-header .demographics .gender-age {
    font-size: 14px;
    margin-left: -55px;
    margin-top: 12px;
}

.new-patient-header .demographics .gender-age span {
    border-bottom: 1px none #ddd;
}

.new-patient-header .identifiers {
    margin-top: 5px;
}

.tag {
    padding: 2px 10px;
}

.tad {
    background: #666 none repeat scroll 0 0;
    border-radius: 1px;
    color: white;
    display: inline;
    font-size: 0.8em;
    padding: 2px 10px;
}

.status-container {
    padding: 5px 10px 5px 5px;
}

.catg {
    color: #363463;
    margin: 25px 10px 0 0;
}

.ui-tabs {
    margin-top: 5px;
}

.simple-form-ui section.focused {
    width: 74.6%;
    min-height: 400px;
}

.col15 {
    min-width: 22%;
    max-width: 22%;
    float: left;
    display: inline-block;
}

.col16 {
    min-width: 56%;
    max-width: 56%;
    float: left;
    display: inline-block;
}
</style>

<script>
    var processdrugdialog;
    jQuery(document).ready(function () {
        processdrugdialog = emr.setupConfirmationDialog({
            selector: '#processDrugDialog',
            actions: {
                confirm: function () {

                    processdrugdialog.close();
                },
                cancel: function () {

                    processdrugdialog.close();
                }
            }
        });
        jq(".dashboard-tabs").tabs();

        jq('#surname').html(strReplace('${patient.names.familyName}') + ',<em>surname</em>');
        jq('#othname').html(strReplace('${patient.names.givenName}') + ' &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <em>other names</em>');
        jq('#agename').html('${patient.age} years (' + moment('${patient.birthdate}').format('DD,MMM YYYY') + ')');


    });

    function strReplace(word) {
        var res = word.replace("[", "");
        res = res.replace("]", "");
        return res;
    }


    function processDrug(drugId, formulationId, frequencyName, days, comments) {
//        console.log(drugId + "-" + formulationId + "-" + frequencyName + "-" + days + "-" + comments);
        jq.getJSON('${ ui.actionLink("pharmacyapp", "drugOrder", "listReceiptDrugAvailable") }', {
            drugId: drugId,
            formulationId: formulationId,
            frequencyName: frequencyName,
            days: days,
            comments: comments
        }).success(function (data) {
            if (data.length === 0) {
                jq('#processDrugOrderFormTable > tbody > tr').remove();
                var tbody = jq('#processDrugOrderFormTable > tbody');
                var row = '<tr align="center"><td colspan="7"> This drug is empty in your store, please indent it</td></tr>';
                tbody.append(row);
            } else {
                jq('#processDrugOrderFormTable > tbody > tr').remove();
                var tbody = jq('#processDrugOrderFormTable > tbody');
                var row;
                jq.each(data, function (i, item) {
                    row = '<tr align="center">' +
                            '<td>' + (i + 1) + ' </td>' +
                            '<td>' + item.dateExpiry + ' </td>' +
                            '<td>' + item.dateManufacture + ' </td>' +
                            '<td>' + item.companyNameShort + ' </td>' +
                            '<td>' + item.batchNo + ' </td>' +
                            '<td>' + item.currentQuantity + ' </td>' +
                            '<td><input type="input" size="4" /> </td>' +
                            '</tr>';
                });
                tbody.append(row);
            }

        }).error(function (xhr, status, err) {
            jq().toastmessage('showNoticeToast', "AJAX error!" + err);
        });
        processdrugdialog.show();
    }


</script>

<div class="clear"></div>

<div id="content">
    <div class="example">
        <ul id="breadcrumbs">
            <li>
                <a href="${ui.pageLink('referenceapplication', 'home')}">
                    <i class="icon-home small"></i></a>
            </li>
            <li>
                <i class="icon-chevron-right link"></i>
                <a href="${ui.pageLink('pharmacyapp', 'opdQueue', [app: 'pharmacyapp.main'])}">PHARMACY</a>
            </li>
            <li>
                <i class="icon-chevron-right link"></i>
                LIST OF ORDER
            </li>
        </ul>
    </div>

    <div class="patient-header new-patient-header">
        <div class="demographics">
            <h1 class="name">
                <span id="surname">${patient.names.familyName},<em>surname</em></span>
                <span id="othname">${patient.names.givenName} &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<em>other names</em>
                </span>

                <span class="gender-age">
                    <span>
                        <% if (patient.gender == "F") { %>
                        Female
                        <% } else { %>
                        Male
                        <% } %>
                    </span>
                    <span id="agename">${patient.age} years (15.Oct.1996)</span>

                </span>
            </h1>

            <br/>

            <div id="stacont" class="status-container">
                <span class="status active"></span>
                Visit Status
            </div>

            <div class="tad">Last Visit</div>
        </div>

        <div class="identifiers">
            <em>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Patient ID</em>
            <span>${patient.getPatientIdentifier()}</span>
            <br>

            <div class="catg">
                <i class="icon-tags small" style="font-size: 16px"></i><small>Category:</small> ${patientType}
            </div>
        </div>

        <div class="close"></div>
    </div>

    <div id="indent-search-result" style="display: block; margin-top:3px;">
        <div role="grid" class="dataTables_wrapper" id="indent-search-result-table_wrapper">
            <table id="indent-search-result-table" class="dataTable" aria-describedby="indent-search-result-table_info">
                <thead>
                <tr role="row">
                    <th class="ui-state-default" role="columnheader">
                        <div class="DataTables_sort_wrapper">
                            <span>S.No</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader">
                        <div class="DataTables_sort_wrapper">
                            <span>Drug Name</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader">
                        <div class="DataTables_sort_wrapper">
                            <span>Formulation</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader">
                        <div class="DataTables_sort_wrapper">
                            <span>Frequency</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader">
                        <div class="DataTables_sort_wrapper">
                            <span>Days</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader">
                        <div class="DataTables_sort_wrapper">
                            <span>Comments</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>
                    <th class="ui-state-default" role="columnheader">
                        <div class="DataTables_sort_wrapper">
                            <span>Actions</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>
                </tr>
                </thead>

                <tbody role="alert" aria-live="polite" aria-relevant="all">
                <% if (drugOrderList != null || drugOrderList != "") { %>
                <% drugOrderList.eachWithIndex { drug, idx -> %>
                <tr>
                    <td>${idx + 1}</td>
                    <td>${drug.inventoryDrug.name}</td>
                    <td>${drug.inventoryDrugFormulation.name}-${drug.inventoryDrugFormulation.dozage}</td>
                    <td>${drug.frequency.name}</td>
                    <td>${drug.noOfDays}</td>
                    <td>${drug?.comments ?: ""}</td>
                    <td><a href="#"
                           onclick="processDrug(${drug.inventoryDrug.id}, ${drug.inventoryDrugFormulation.id}, '${drug.frequency.name}', ${drug.noOfDays}, '${drug.comments}');"><i
                                class="icon-signin small">Process</i></a></td>
                </tr>
                <% } %>
                <% } else { %>
                <tr align="center">
                    <td colspan="6">No Drugs Found</td>
                </tr>
                <% } %>
                </tbody>
            </table>

        </div>
    </div>

    <div id="processDrugDialog" class="dialog" style="display: none; width: 80%">
        <div class="dialog-header">
            <i class="icon-folder-open"></i>

            <h3>Process Drug Order</h3>
        </div>

        <form id="dialogForm">

            <div class="dialog-content">
                <form method="post" id="processDrugOrderForm" class="box">
                    <table class="box" id="processDrugOrderFormTable">
                        <thead>
                        <tr>
                            <th>S.No</th>
                            <th>Expiry</th>
                            <th title="Date of manufacturing">DM</th>
                            <th>Company</th>
                            <th>Batch No.</th>
                            <th title="Quantity available">Available</th>
                            <th title="Issue quantity">Issue</th>
                        </tr>
                        </thead>
                        <tbody></tbody>

                    </table>
                </form>
                <br/>


                <span class="button confirm right">Issue Drug</span>
                <span class="button cancel">Cancel</span>
            </div>
        </form>
    </div>
</div>
