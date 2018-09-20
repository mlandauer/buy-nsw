(function () {
  'use strict'
  window.ProcurementHub = window.ProcurementHub || {}

  function CollapsibleNavModule (options) {
    this.el = options.el
    this.$el = $(this.el)
    this.collapseClass = 'collapsed'

    this.$triggers = this.$el.find('*[data-collapse="toggle"]')
    this.bindEvents()
  }

  CollapsibleNavModule.prototype.bindEvents = function bindEvents () {
    this.$triggers.on('click', $.proxy(this.toggleDisplay, this))
  }

  CollapsibleNavModule.prototype.toggleDisplay = function toggleDisplay () {
    this.$el.toggleClass(this.collapseClass)
  }

  window.ProcurementHub.CollapsibleNavModule = CollapsibleNavModule
}())

$(function () {
  $('*[data-module="collapsible-nav"]').each(function (i, element) {
    new ProcurementHub.CollapsibleNavModule({
      el: element
    })
  })
})
