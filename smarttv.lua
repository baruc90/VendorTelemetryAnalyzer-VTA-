
local smartv_proto = Proto("SmartTVTelem", "Smart TV Telemetry")

local pf_event   = ProtoField.string("smarttv.event", "Evento")
local pf_channel = ProtoField.string("smarttv.channel", "Canal")
local pf_content = ProtoField.string("smarttv.contentId", "Contenido ID")
smartv_proto.fields = { pf_event, pf_channel, pf_content }


local http_host_field = Field.new("http.host")
local http_file_data = Field.new("http.file_data")

TABLAS DE DOMINIOS

local telemetry_domains = {
    -- LG (webOS).
    ["lgsmartad.com"] = true,
    ["ngfts.lge.com"] = true,
    ["e1.api.lg.com"] = true,
    ["lgtvsdp.com"] = true,
    ["lgad.cjpowercast.com"] = true,
    ["lgemp.designspacedev.com"] = true,
    ["sms.lgappstv.com"] = true,
    ["lgappstv.com"] = true,
    ["smartshare.lge.com"] = true,
    ["lginnotek.com"] = true,
    ["lgdsp.com"] = true,

    -- Samsung (Tizen).
    ["samsungacr.com"] = true,
    ["log-ingestion-eu.samsungacr.com"] = true,
    ["log-ingestion-us.samsungacr.com"] = true,
    ["dcp.samsung.com"] = true,
    ["osb.samsungqbe.com"] = true,
    ["samsungads.com"] = true,
    ["ad.samsungadhub.com"] = true,
    ["gpm.samsungqbe.com"] = true,
    ["samsungotn.net"] = true,
    ["samsungcloud.com"] = true,
    ["samsungapps.com"] = true,
    ["iot.samsung.com"] = true,
    ["lcprd1.samsungcloudsolution.net"] = true,

    -- Vizio (SmartCast).
    ["vizio.com"] = true,
    ["vizio.tv"] = true,
    ["tvinteractive.tv"] = true,
    ["vizioads.com"] = true,
    ["cognitivessl.com"] = true,
    ["controltv.tv"] = true,

    -- Sony (Google TV / Android TV).
    ["sony.com"] = true,
    ["sony.net"] = true,
    ["bravia.sony.com"] = true,
    ["snyders.com"] = true,
    ["sonyentertainmentnetwork.com"] = true,
    ["sony.tv"] = true,

    -- TCL / Roku TV.
    ["tcl.com"] = true,
    ["tclclouds.com"] = true,
    ["roku.com"] = true,
    ["rokuads.com"] = true,
    ["roku.com.br"] = true,
    ["imgix.net"] = true,
    ["rokuvideo.com"] = true,

    -- Amazon Fire TV / Fire OS.
    ["amazon.com"] = true,
    ["amazonaws.com"] = true,
    ["amazon-adsystem.com"] = true,
    ["device-metrics-us.amazon.com"] = true,
    ["firetv.amazon.com"] = true,
    ["amazonvideo.com"] = true,
    ["alexa.amazon.com"] = true,

    -- Android TV / Google TV.
    ["google.com"] = true,
    ["google-analytics.com"] = true,
    ["googletagmanager.com"] = true,
    ["doubleclick.net"] = true,
    ["googleadservices.com"] = true,
    ["googleapis.com"] = true,
    ["gstatic.com"] = true,
    ["gvt1.com"] = true,
    ["android.com"] = true,

    -- Xiaomi / Mi TV.
    ["xiaomi.com"] = true,
    ["mi.com"] = true,
    ["miui.com"] = true,
    ["xiaomi.net"] = true,
    ["mijia.xiyuner.com"] = true,

    -- Hisense (Vidaa OS, Android TV).
    ["hisense.com"] = true,
    ["hisensetv.com"] = true,
    ["vidaa.com"] = true,

    -- Philips (Saphi, Android TV).
    ["philips.com"] = true,
    ["tpvision.com"] = true,
    ["smarttv.philips.com"] = true,
    ["philips-hue.com"] = true,

    -- Panasonic (My Home Screen).
    ["panasonic.com"] = true,
    ["panasonic.net"] = true,
    ["myhomescreen.tv"] = true,

    -- Servicios comunes de analítica, publicidad y telemetría.
    ["scorecardresearch.com"] = true,
    ["moatads.com"] = true,
    ["doubleverify.com"] = true,
    ["crashlytics.com"] = true,
    ["appsflyer.com"] = true,
    ["adjust.com"] = true,
    ["segment.io"] = true,
    ["mixpanel.com"] = true,
    ["amplitude.com"] = true,
    ["facebook.com"] = true,
    ["facebook.net"] = true,
    ["bat.bing.com"] = true,
    ["mookie1.com"] = true,
    ["rubiconproject.com"] = true,
    ["criteo.com"] = true,
    ["taboola.com"] = true,
    ["outbrain.com"] = true,
    ["yieldmo.com"] = true,
    ["adnxs.com"] = true,
    ["pubmatic.com"] = true,
    ["spotx.tv"] = true,
    ["freewheel.tv"] = true,
    ["conviva.com"] = true,
    ["nicepeopleatwork.com"] = true,
    ["mux.com"] = true,
    ["newrelic.com"] = true,
    ["bugsnag.com"] = true,
    ["sentry.io"] = true,
    ["braze.com"] = true,
    ["leanplum.com"] = true,
    ["airship.com"] = true,
    ["onesignal.com"] = true,
    ["smartadserver.com"] = true,
    ["adform.net"] = true,
    ["adroll.com"] = true,
    ["quantcount.com"] = true,
    ["chartbeat.com"] = true,
    ["parsely.com"] = true,
    ["hotjar.com"] = true,
    ["fullstory.com"] = true,
    ["clicktale.net"] = true,
    ["optimizely.com"] = true,
    ["tealium.com"] = true,
    ["ensighten.com"] = true,
    ["adobe.com"] = true,
    ["omtrdc.net"] = true,
    ["demdex.net"] = true,
    ["everesttech.net"] = true,
}


local generic_domains = {
    -- Se incluyen aquí los dominios principales.
}

local function host_in_table(host, table)
    local lower_host = string.lower(host)
    for domain in pairs(table) do
        if lower_host:find(domain, 1, true) then
            return true
        end
    end
    return false
end

local function log_telemetry(host)
    local logfile = io.open("telemetry.log", "a")
    if logfile then
        logfile:write(os.date("%Y-%m-%d %H:%M:%S") .. " - " .. host .. "\n")
        logfile:close()
    end
end


function smartv_proto.dissector(buffer, pinfo, tree)
    
    local host_extracted = http_host_field()
    if not host_extracted then
        return  
    end
    local host = tostring(host_extracted)


    local is_specific = host_in_table(host, telemetry_domains)
    local is_generic  = host_in_table(host, generic_domains)

    if not (is_specific or is_generic) then
        return  
    end

   
    pinfo.cols.protocol = "SmartTVTelemetry"

    
    local subtree = tree:add(smartv_proto, buffer(), "Detección de Telemetría Smart TV")
    if is_specific then
        subtree:add_expert_info(PI_SECURITY, PI_WARN, "Telemetría específica detectada: " .. host)
        pinfo.cols.info:prepend("[TELEMETRÍA] ")
        -- Registro en archivo de log.
        log_telemetry(host)
    else
        subtree:add_expert_info(PI_SECURITY, PI_NOTE, "Posible telemetría (dominio genérico): " .. host)
        pinfo.cols.info:prepend("[? TELEMETRÍA GENÉRICA] ")
    end

    local body_extracted = http_file_data()
    if body_extracted then
        local body_str = tostring(body_extracted)
        local json_ok, json_data = pcall(require("json").decode, body_str)
        if json_ok and json_data then
            subtree:add(pf_event, json_data.event or "N/A")
            subtree:add(pf_channel, json_data.channel or "N/A")
            subtree:add(pf_content, json_data.contentId or "N/A")
        end
    end
end

register_postdissector(smartv_proto)