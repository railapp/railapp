require File.dirname(__FILE__) + '/../test_helper.rb'

module ConditionsTests
  class MagicMethodsTest < ActiveSupport::TestCase
    def test_virtual_columns
      search = Account.new_search
      conditions = search.conditions
      conditions.hour_of_created_gt = 2
      assert_equal ["(strftime('%H', \"accounts\".\"created_at\") * 1) > ?", 2], conditions.sanitize
      conditions.dow_of_created_at_most = 5
      assert_equal ["(strftime('%H', \"accounts\".\"created_at\") * 1) > ? AND (strftime('%w', \"accounts\".\"created_at\") * 1) <= ?", 2, 5], conditions.sanitize
      conditions.month_of_created_at_nil = true
      assert_equal ["(strftime('%H', \"accounts\".\"created_at\") * 1) > ? AND (strftime('%w', \"accounts\".\"created_at\") * 1) <= ? AND (strftime('%m', \"accounts\".\"created_at\") * 1) IS NULL", 2, 5], conditions.sanitize
      conditions.min_of_hour_of_month_of_created_at_nil = true
      assert_equal ["(strftime('%H', \"accounts\".\"created_at\") * 1) > ? AND (strftime('%w', \"accounts\".\"created_at\") * 1) <= ? AND (strftime('%m', \"accounts\".\"created_at\") * 1) IS NULL AND (strftime('%m', (strftime('%H', (strftime('%M', \"accounts\".\"created_at\") * 1)) * 1)) * 1) IS NULL", 2, 5], conditions.sanitize
      assert_nothing_raised { search.all }
    end
  end
  
  def test_method_conflicts
    conditions = Searchlogic::Cache::AccountConditions.new
    assert_nil conditions.id
  end
end