class Admin::TagProblemReport < ApplicationService
  extend Forwardable

  def_delegators :build_operation, :problem_report, :form

  def initialize(problem_report_id:, tags:)
    @problem_report_id = problem_report_id
    @tags = tags
  end

  def call
    if build_operation.success? && persist_tags
      self.state = :success
    else
      self.state = :failure
    end
  end

  private

  attr_reader :problem_report_id, :tags

  def build_operation
    @build_operation ||= Admin::BuildTagProblemReport.call(
      problem_report_id: problem_report_id
    )
  end

  def persist_tags
    form.validate(tags: tags) && form.save
  end
end
