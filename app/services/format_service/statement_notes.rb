# frozen_string_literal: true
module FormatService
  class StatementNotes
    include Callable
    include PayrollPeriodCountable

    attr_reader :payroll, :salary, :notes

    def initialize(payroll)
      @payroll = payroll
      @salary = payroll.salary
      @notes = []
    end

    def call
      generate_notes
      notes
    end

    private

    def generate_notes
      employment_date_notes
      income_notes
      deduction_notes
      extra_notes
    end

    def income_notes
      hourly_based_note(payroll.parttime_hours, "工作時數")
      hourly_based_note(payroll.vacation_refund_hours, "特休折現")
      overtime_notes
    end

    def deduction_notes
      hourly_based_note(payroll.leavetime_hours, "扣薪事假")
      hourly_based_note(payroll.sicktime_hours, "扣薪病假")
    end

    def hourly_based_note(hours, title)
      notes << "#{title} #{hours} 小時" if hours.positive?
    end

    def employment_date_notes
      return if salary.partner?
      notes << "#{salary.term.start_date} 到職" if first_month?
      notes << "#{salary.term.end_date} 離職" if final_month?
    end

    def overtime_notes
      payroll.overtimes.map do |overtime|
        notes << "#{overtime.date.strftime('%Y-%m-%d')} 加班 #{overtime.hours} 小時"
      end
    end

    def extra_notes
      payroll.extra_entries.map do |extra_entry|
        notes << extra_entry.note if extra_entry.note?
      end
    end
  end
end
