

##
# Using test-prof's before_all block to safely wrap shared data in a transaction,
# shared_let acts similarly to +let(:foo) { value }+ but initialized the value only once
# Changes _within_ an example will be rolled back by database cleaner,
# and the creation is rolled back in an after_all hook.
#
# Caveats: Set +reload: true+ if you plan to modify this value, otherwise Rails may still
# have cached the local value. This will perform a database update, but is much faster
# than creating new records (especially, work packages).
#
# Since test-prof added `let_it_be` this is only a wrapper for it
# before_all / let_it_be fixture
def shared_let(key, reload: true, refind: false, &block)
  let_it_be(key, reload: reload, refind: refind, &block)
end
