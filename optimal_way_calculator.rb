# frozen_string_literal: true

class OptimalWayCalculator
  def initialize(matrix:, from:, to:)
    @matrix   = matrix
    @from     = from
    @to       = to
    @minimums = {}
    @points   = matrix.keys
  end

  def calculate
    clone_matrix!
    calculate_minimums!

    way(from, to).round(5)
  end

  private

  attr_reader :matrix, :from, :to, :minimums, :points

  def clone_matrix!
    @minimums = matrix.dup
  end

  def calculate_minimums!
    points.each do |first|
      points.each do |second|
        points.each { |third| set_minimum(first, second, third) }
      end
    end
  end

  def set_minimum(first, second, third)
    return if !way_exist?(second, first) || !way_exist?(first, third)
    return unless !way_exist?(second, third) || better_way?(first, second, third)

    minimums[second][third] = way(second, first) + way(first, third)
  end

  def way_exist?(from, to)
    minimums[from].key?(to)
  end

  def better_way?(first, second, third)
    way(second, third) > way(second, first) + way(first, third)
  end

  def way(from, to)
    minimums.dig(from, to)
  end
end
