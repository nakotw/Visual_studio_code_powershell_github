#création d'un fichier avec contenu
mkdir c:\intune\Edge
$EDGE_XML_path = "c:\intune\Edge\Edge_ext_app.xml"
$EDGE_XML_file = @("
<?xml version="1.0" encoding="UTF-8"?>
<DefaultAssociations>
  <Association Identifier=".htm" ProgId="MSEdgeHTM" ApplicationName="Microsoft Edge" />
  <Association Identifier=".html" ProgId="MSEdgeHTM" ApplicationName="Microsoft Edge" />
  <Association Identifier="http" ProgId="MSEdgeHTM" ApplicationName="Microsoft Edge" />
  <Association Identifier="https" ProgId="MSEdgeHTM" ApplicationName="Microsoft Edge" />
  <Association Identifier="mailto" ProgId="Outlook.URL.mailto.15" ApplicationName="Outlook" />
  <Association Identifier="microsoft-edge" ProgId="MSEdgeHTM" ApplicationName="Microsoft Edge" />
  </DefaultAssociations>
")

$EDGE_XML_file | Out-File $(New-Item $EDGE_XML_path -Type File -Force)
