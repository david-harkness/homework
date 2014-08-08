require_relative '../minitest_helper'

class OrganizationTest < MiniTest::Unit::TestCase
  def run(*args, &block)
    Sequel::Model.db.transaction(:rollback=>:always) {super}
  end

  def setup
    @user1        = create(:user)
    @root         = create(:organization, name:'root org')

    @mid_org_a    = create(:organization, type:'organization', name:'mid org a', root_id:@root.id)
    @mid_org_b    = create(:organization, type:'organization', name:'mid org b', root_id:@root.id)

    @child_org_a1 = create(:organization, type:'child', name:'child_org a1', root_id:@root.id, org_id:@mid_org_a.id)
    @child_org_a2 = create(:organization, type:'child', name:'child_org a2', root_id:@root.id, org_id:@mid_org_a.id)

    @child_org_b1 = create(:organization, type:'child', name:'child_org b1', root_id:@root.id, org_id:@mid_org_b.id)
    @child_org_b2 = create(:organization, type:'child', name:'child_org b2', root_id:@root.id, org_id:@mid_org_b.id)
  end


  def test_user_has_a_name #sanity check
    assert_equal "John Smith", @user1.name
  end

  def test_root_can_grant_admin_to_user
    @root.grant('admin', @user1 )
    assert @root.user_has_role?('admin', @user1)
  end

  def test_org_sees_admin_from_root
    @root.grant('admin', @user1 )
    assert @mid_org_a.user_has_role?('admin', @user1)
  end

  def test_child_sees_admin_from_root
    @root.grant('admin', @user1 )
    assert @child_org_b2.user_has_role?('admin', @user1)
  end

  def test_child_grant_overrides_org
    @mid_org_a.grant('admin', @user1 )
    @child_org_a1.grant('user', @user1)
    assert @child_org_a1.user_has_role?('user', @user1)
  end

  def test_denied_child_can_not_see
    @root.grant('admin', @user1 )
    @mid_org_a.grant('denied', @user1)
    refute @child_org_a1.user_has_role?('admin', @user1)
  end

  def test_org_grant_overrides_root_other_nodes_are_not_effected
    @root.grant('admin', @user1 )
    @mid_org_a.grant('user', @user1)
    assert @child_org_b2.user_has_role?('admin', @user1)
    assert @child_org_a1.user_has_role?('user', @user1)
  end

  def test_my_role_remains_the_same
    @root.grant('admin', @user1 )
    assert_equal @root.what_is_my_role?(@user1), 'admin'
    assert_equal @mid_org_a.what_is_my_role?(@user1), 'admin'
    assert_equal @child_org_a1.what_is_my_role?(@user1), 'admin'
  end

  def test_inheritance
    @root.grant('admin', @user1 )
    @mid_org_a.grant('user', @user1 )
    assert_equal @root.what_is_my_role?(@user1), 'admin'
    assert_equal @mid_org_a.what_is_my_role?(@user1), 'user'
    assert_equal @child_org_a1.what_is_my_role?(@user1), 'user'
  end

  def test_denied_has_no_role_sibling_child_still_has_access
    @root.grant('admin', @user1 )
    @mid_org_a.grant('user', @user1 )
    @child_org_a1.grant('denied', @user1 )
    assert_equal @root.what_is_my_role?(@user1), 'admin'
    assert_equal @mid_org_a.what_is_my_role?(@user1), 'user'
    assert_equal @child_org_a1.what_is_my_role?(@user1), nil
    assert_equal @child_org_b1.what_is_my_role?(@user1), 'admin'
  end
end