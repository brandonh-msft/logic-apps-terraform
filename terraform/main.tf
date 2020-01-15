resource "azurerm_resource_group" "rg" {
  name     = "${var.resourceGroupBaseName}-${var.environmentName}"
  location = var.location
}

resource "azurerm_logic_app_workflow" "wf" {
  name                = "bh-hardac-flow"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

data "local_file" "dnLogicApp" {
  filename = "${path.module}/../workflow.json"
}

resource "random_uuid" "deploymentName" {}

resource "azurerm_template_deployment" "logicApp" {
  resource_group_name = azurerm_resource_group.rg.name
  deployment_mode     = "Incremental"
  name                = random_uuid.deploymentName.result
  parameters = {
    workflows_flow_name = azurerm_logic_app_workflow.wf.name
    location            = var.location
  }
  template_body = data.local_file.dnLogicApp.content
}
# resource "azurerm_logic_app_trigger_custom" "trig" {
#   name         = "manual"
#   logic_app_id = azurerm_logic_app_workflow.wf.id

#   body = <<BODY
#   {
#     "type": "Request",
#     "kind": "Http",
#     "inputs": {
#         "schema": {}
#     }
#   }
# BODY
# }

# resource "azurerm_logic_app_action_custom" "actions" {
#   name = "allTheActions"
#   logic_app_id = azurerm_logic_app_workflow.wf.id
#   body = <<BODY
#   {
#       "Response": {
#           "runAfter": {},
#           "type": "Response",
#           "kind": "Http",
#           "inputs": {
#               "body": "@triggerBody()",
#               "statusCode": 202
#           }
#       }
#   }
# BODY
# }
