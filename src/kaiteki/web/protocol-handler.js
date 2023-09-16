var isProtocolHandlerRegistered = null;

try {
    let url = "https://" + window.location.host + "/#/web-protocol-handler/?url=%s";
    navigator.registerProtocolHandler("web+kaitekisocial", url, "Kaiteki");
    isProtocolHandlerRegistered = true;
} catch (e) {
    console.error("Couldn't register protocol handler", e);
    isProtocolHandlerRegistered = false;
}