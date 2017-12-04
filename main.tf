locals {
  namespace_name      = "${var.product}-${var.env}"
  resource_group_name = "${var.product}-${var.env}"
}

resource "azurerm_resource_group" "servicebus_resource_group" {
  name     = "${local.resource_group_name}"
  location = "${var.location}"
}

module "namespace" {
  // TODO: reference a specific release
  source                = "git@github.com:hmcts/terraform-module-servicebus-namespace.git"
  name                  = "${local.namespace_name}"
  location              = "${var.location}"
  resource_group_name   = "${local.resource_group_name}"
}

module "private_beta_activation_topic" {
  // TODO: reference a specific release
  source                = "git@github.com:hmcts/terraform-module-servicebus-topic.git"
  name                  = "idam.private-beta.account.activation"
  resource_group_name   = "${local.resource_group_name}"
  namespace_name        = "${local.namespace_name}"
}

module "private_beta_activation_subscription" {
  // TODO: reference a specific release
  source                = "git@github.com:hmcts/terraform-module-servicebus-subscription.git"
  name                  = "idam.private-beta.account.activation.subscription"
  resource_group_name   = "${local.resource_group_name}"
  namespace_name        = "${local.namespace_name}"
  topic_name            = "${module.private_beta_activation_topic.name}"
}
