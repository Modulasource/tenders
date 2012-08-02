// +-----------------------------------------------------------------------+
// | SpeedZilla - a PHP/Ajax based bandwidth test
// | Copyright (C)2008 E. Haydont - J.P. Fortune speedzilla@speedzilla.net
// |
// | This program is free software: you can redistribute it and/or modify
// | it under the terms of the GNU Affero General Public License as
// | published by the Free Software Foundation, either version 3 of the
// | License, or (at your option) any later version.
// |
// | This program is distributed in the hope that it will be useful,
// | but WITHOUT ANY WARRANTY; without even the implied warranty of
// | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// | GNU Affero General Public License for more details.
// |
// | You should have received a copy of the GNU Affero General Public License
// | along with this program.  If not, see <http://www.gnu.org/licenses/>.
// +-----------------------------------------------------------------------+

var g_count = 0;
var g_hi_lo = 'low';
var g_upstart, g_upstop, g_uptime, g_lattimestart, g_dbw, g_ubw;
var g_difftime = new Array();

function clearconsole() {
    this.document.getElementById('console').value = '';
}

function console(msg) {
    var ctxta = this.document.getElementById('console');
    if(ctxta.value=='') {
        ctxta.value += msg;
    } else {
        ctxta.value += '\r\n' + msg;
    }
    ctxta.scrollTop = ctxta.scrollHeight;
}

function clearresults() {
    this.document.getElementById('results').innerHTML = '';
}

function results(msg) {
    this.document.getElementById('results').innerHTML += msg + '<br/>';
}

function bargraph(dir, bw, msg) {
    if (bw == 0) {
        this.document.getElementById(dir + 'bar').style.width = '5px';
    } else {
        this.document.getElementById(dir + 'bar').style.width = (Math.log(bw) * 22.05387 / Math.log(10) - 23) + '%';
    }
    this.document.getElementById(dir + 'text').innerHTML = '<strong>' + msg + '</strong>';
}

function showstatus(msg) {
    this.document.getElementById('status').innerHTML = msg;
}

function hidebutton(bid) {
    this.document.getElementById(bid).style.display = 'none';
}

function showbutton(bid) {
    this.document.getElementById(bid).style.display = '';
}

function gettimestamp() {
    var date = new Date();
    return (date.getTime());
}

function SpeedZilla(pstep) {
    var bw, lattime, nstep, ipi, bdifftime;
    switch (pstep) {
    case 0 : // initial bandwitdh evaluation
        hidebutton('stb');
        showstatus('&nbsp;'+str_status_initial_msg);
        clearconsole();
        clearresults();
        console(str_console_start);
        bargraph('dw', 0, '&nbsp;');
        bargraph('up', 0, '&nbsp;');
        new Ajax.Updater('spdtc', 'do.jsp'+sSessionId, {
            asynchronous : true,
            evalScripts : true,
            postBody : 'action=eval&ns=1'
        });
        g_count = 2;
        break;
    case 1 : // determine download bandwitdh
        if(g_count==2) {
            console(str_console_det_dw_bw);
            console(str_console_Downloading + g_dwweight + str_kb + '...');
        }
        console(str_console_measure+(3-g_count));
        new Ajax.Updater('spdtc', 'do.jsp'+sSessionId, {
            asynchronous : true,
            evalScripts : true,
            postBody : 'action=dw&hilo=' + g_hi_lo + '&ns='+(g_count!=0?1:2)
        });
        break;
    case 2 : // display dw bw, determine upload bandwidth
        // choose best result, calculate bw
        bdifftime=g_difftime[0];
        if(g_difftime[1]<g_difftime[0])
             bdifftime=g_difftime[1];
        if(g_difftime[2]<bdifftime)
             bdifftime=g_difftime[2];
        g_dbw = Math.round(((g_dwweight * 8 * 1024) / bdifftime) / 1000);
        console(str_console_det_best_time + bdifftime.toPrecision(4) + ' s');
        console(str_console_Downloading_time + bdifftime.toPrecision(4) + ' s');
        console(str_console_Calc_dw_bw + g_dbw + ' ' + str_kbps);
        results(str_results_Download + '<br/>' + g_dbw + ' ' + str_kbps + ' &middot; ' + Math.round(g_dbw / 8) + ' ' + str_kbyps);
        console(str_console_det_up_bw);
        console(str_console_Uploading + g_upweight + str_kb + '...');
        // update info for download bw
        bargraph('dw', g_dbw, '&nbsp;&nbsp;' + g_dbw + ' ' + str_kbps);
        // determine raw upload bandwitdh
        new Ajax.Updater('spdtc', 'do.jsp'+sSessionId, {
            asynchronous : true,
            evalScripts : true,
            postBody : 'action=upstart&ns=3&hilo=' + g_hi_lo
        });
        g_count = 3;
        break;
    case 3 : // display up bw, determine latency
        g_uptime = g_upstop - g_upstart;
        g_ubw = Math.round((g_upweight * 8 * 1024) / g_uptime);
        console(str_console_Uploading_time + (g_uptime / 1000).toPrecision(4) + ' s');
        console(str_console_Calc_up_bw + g_ubw + ' ' + str_kbps);
        results(str_results_Upload + '<br/>' + g_ubw + ' ' + str_kbps + ' &middot; ' + Math.round(g_ubw / 8) + ' ' + str_kbyps);
        // determine lantency
        console(str_console_det_lat);
        // update info for upload bw
        bargraph('up', g_ubw, '&nbsp;&nbsp;' + g_ubw + ' ' + str_kbps);
        g_lattimestart = gettimestamp();
    case 4 : // no break
        if (!g_count--) {
            nstep = 5;
        } else {
            nstep = 4;
        }
        new Ajax.Updater('spdtc', 'do.jsp'+sSessionId, {
            asynchronous : false,
            evalScripts : true,
            postBody : 'action=latency&ns=' + nstep + '&counter=' + g_count
        });
        break;
    case 5 : // display latency, compute ipi
        lattime = (gettimestamp() - g_lattimestart) / 8;
        console(str_console_latency + lattime + ' ms');
        results(str_results_Latency + lattime + ' ms');
        console(str_console_det_ipi);
        ipi = 20*Math.log((2*g_dbw + g_ubw)+(30*(g_dbw + g_ubw)/lattime))/Math.log(10);
        ipi = Math.round(ipi);
        results(str_results_IPI + ipi);
        showstatus('&nbsp;' + str_status_ipi + '&nbsp;&nbsp;&nbsp;&nbsp;<span class="ipires">IPI = ' + ipi + '</span>');
        showbutton('stb');
        console(str_console_Calc_ipi + ipi);
        console(str_console_meas_terminated);
        new Ajax.Updater('spdtc', 'do.jsp'+sSessionId, {
            asynchronous : true,
            evalScripts : true,
            postBody : 'action=sc'
        });
        break;
    default :
        break;
    }
}