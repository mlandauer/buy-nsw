class SlackMessage
  include Rails.application.routes.url_helpers

  def new_product_order(order)
    message_type_with_button(
      :new_product_order,
      params: {
        buyer: link_to(order.buyer.name, ops_buyer_url(order.buyer)),
        organisation: order.buyer.organisation,
        product: link_to(order.product.name, pathway_product_url(order.product.section, order.product))
      },
      button_url: ops_product_orders_url
    )
  end

  def buyer_application_submitted(application)
    message_type_with_button(
      :buyer_application_submitted,
      params: {
        buyer: application.buyer.name,
        organisation: application.buyer.organisation
      },
      button_url: ops_buyer_application_url(application)
    )
  end

  def seller_version_submitted(version)
    message_type_with_button(
      :seller_version_submitted,
      params: {
        seller: version.name
      },
      button_url: ops_seller_application_url(version)
    )
  end

  def new_problem_report(report)
    fields = [
      {
        title: 'Task',
        value: report.task,
      },
      {
        title: 'Issue',
        value: report.issue,
      },
    ]

    if report.user.present?
      fields << {
        title: 'User',
        value: report.user.email,
      }
    end

    message_type_with_button(
      :new_problem_report,
      button_url: ops_problem_report_url(report),
      fields: fields,
    )
  end

  def message_type_with_button(type, params: {}, button_url:, fields: nil)
    message_with_button(
      text: I18n.t("slack_messages.#{type}.text", params),
      button_text: I18n.t("slack_messages.#{type}.button"),
      button_url: button_url,
      fields: fields,
    )
  end

  def message_with_button(text:, button_text:, button_url:, fields: nil)
    attachment = {
      fallback: "#{button_text} at #{button_url}",
      actions: [
        type: "button",
        text: button_text,
        url: button_url
      ]
    }

    if fields.present?
      attachment[:fields] = fields
    end

    message(
      text: text,
      attachments: [ attachment ],
    )
  end

  def message(params)
    if slack_webhook_url.present?
      RestClient.post slack_webhook_url, params.to_json, {content_type: :json}
    end
  end

  private

  def link_to(text, url)
    "<#{url}|#{text}>"
  end

  def slack_webhook_url
    ENV["SLACK_WEBHOOK_URL"]
  end
end
