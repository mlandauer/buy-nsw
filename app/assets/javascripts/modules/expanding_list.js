(function () {
  'use strict'
  window.ProcurementHub = window.ProcurementHub || {}

  function ExpandingListModule (options) {
    this.$el = options.$el
    this.$template = this.buildTemplateForm()
    this.$container = this.$el.find('ol')

    this.inlineLabels = this.hasInlineLabels()
    this.objectName = this.$el.attr('data-object-name')
    this.maxItems = this.$el.attr('data-expanding-list-max')

    if (this.objectName == null) {
      this.objectName = 'row'
    }

    this.$addLink = this.buildAddLink()

    this.setupForm()
  }

  ExpandingListModule.prototype.setupForm = function setupForm () {
    this.$el.addClass('expanding-list')

    if (!this.listFull()) {
      this.insertAddLink()
    }

    var $rows = this.$container.find('li')
    $($rows).each(
      $.proxy(this.buildDeleteLink, this)
    )
  }

  ExpandingListModule.prototype.addNewRow = function addNewRow (event) {
    event.preventDefault()

    if (this.listFull() === true) {
      return false
    }

    var $newRow = this.$template.clone()

    var $visibleInputs = $newRow.find('input[type=text]')

    var newIndex = this.getNewIndex()
    var visibleIndex = newIndex + 1

    $visibleInputs.each($.proxy(function (i, input) {
      var $input = $(input)
      var $label = $input.siblings('label')

      var newID = this.buildFieldID($input.attr('id'), newIndex)

      if (this.inlineLabels === true) {
        $label.text(visibleIndex + '.')
      }

      $label.attr('for', newID)
      $input.attr('id', newID)
    }, this))

    $newRow.appendTo(this.$container)
    $visibleInputs.first().focus()

    if (this.listFull()) {
      this.removeAddLink()
    }
  }

  ExpandingListModule.prototype.listFull = function listFull () {
    return (this.maxItems !== null && this.$container.find('li:not(.removed)').length >= this.maxItems)
  }

  ExpandingListModule.prototype.deleteRow = function deleteRow ($row, event) {
    event.preventDefault()

    var $inputField = $row.find('input[type=text]')
    var $deleteLink = $row.find('a')

    $row.addClass('removed')
    $inputField.attr('disabled', true)
    $deleteLink.remove()

    if (this.listFull() === false) {
      this.insertAddLink()
    }
  }

  ExpandingListModule.prototype.buildAddLink = function buildAddLink () {
    var $addLink = $('<a></a>')
    $addLink.text('Add another ' + this.objectName)
    $addLink.attr('href', '#')

    return $addLink
  }

  ExpandingListModule.prototype.insertAddLink = function insertAddLink () {
    // Always remove the link to avoid doubling-up
    this.$addLink.remove()

    this.$addLink.appendTo(this.$el)
    this.$addLink.on('click', $.proxy(this.addNewRow, this))
  }

  ExpandingListModule.prototype.removeAddLink = function removeAddLink () {
    this.$addLink.remove()
  }

  ExpandingListModule.prototype.buildDeleteLink = function buildDeleteLink (i, element) {
    var $deleteContainer = $('<div></div>').addClass('delete-action')
    var $deleteLink = $('<a></a>')
    var $element = $(element)
    var $input = $element.find('input')

    if ($input.val().length === 0) { return }

    $deleteLink.text('Delete this ' + this.objectName)
    $deleteLink.attr('href', '#')
    $deleteLink.on('click', $.proxy(this.deleteRow, this, $element))

    $deleteLink.appendTo($deleteContainer)
    $deleteContainer.appendTo($element)
  }

  ExpandingListModule.prototype.buildTemplateForm = function buildTemplateForm () {
    var $templateForm = this.$el.find('li:first-of-type').clone()
    var $textInput = $templateForm.find('input[type=text]')

    $textInput.val('')
    return $templateForm
  }

  ExpandingListModule.prototype.buildFieldID = function buildFieldID (id, newIndex) {
    // The following expressions are designed to match everything in the following
    // strings apart from the '[0]' index:
    //
    //    application_accreditations_attributes_0
    //
    var idExpr = /([\w]+)_0$/

    var matches = id.match(idExpr)
    var newFieldID = matches[1] + '_' + newIndex

    return newFieldID
  }

  ExpandingListModule.prototype.getNewIndex = function getNewIndex () {
    var $lastEl = this.$el.find('li:last-of-type')
    var $label = $lastEl.find('label')

    var indexExpr = /(\d+)\.$/
    var matches = $label.text().match(indexExpr)

    var lastIndex = parseInt(matches[1] - 1)

    return (lastIndex + 1)
  }

  ExpandingListModule.prototype.hasInlineLabels = function hasInlineLabels () {
    var classes = this.$el.attr('class')
    var matches = classes.match(/with-inline-labels/)

    if (matches !== null && matches.length >= 1) {
      return true
    } else {
      return false
    }
  }

  window.ProcurementHub.ExpandingListModule = ExpandingListModule
}())

$(function () {
  $('*[data-module="expanding-list"]').each(function (i, element) {
    // eslint-disable-next-line no-new
    new window.ProcurementHub.ExpandingListModule({
      $el: $(element)
    })
  })
})
