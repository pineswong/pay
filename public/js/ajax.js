/**
 * @file		ajax.js
 * @authors Pine Wong (pinewong@163.com)
 * @date    2016-06-12 20:37:39
 * @version $Id$
 */

// 创建账户
function newFuel() {
	if (!$('#fuel_index').is(':hidden')) {
		item = $('#fuel_index');
	}
	if (!$('#fuel_new').is(':hidden')) {
		item = $('#fuel_new');
	}
	if (!$('#fuel_edit').is(':hidden')) {
		item = $('#fuel_edit');
	}
	item.fadeOut(300, function() {
		$('#fuel_new').fadeIn(300);
	});
}
function createFuel(form) {
	$.ajax({
		url: 'http://localhost:3000/api/fuels',
		type: 'post',
		data: $(form).serialize(),
		complete: function(xhr) {
			if (xhr.status == 201) {
				alert('创建账户成功！\n' + xhr.responseText);
				window.location.href="/fuels"; 
			} else {
				alert('创建账户失败！\n' + xhr.responseText);
			}
      // {
      //  "readyState":4,
      //  "responseText":"{\"success\":\"测试成功\"}",
      //  "responseJSON":{"success":"测试成功"},
      //  "status":200,
      //  "statusText":"OK"
      // }
    },
  });

	return false;
}

// 修改账户
function editFuel(id) {
	if (!$('#fuel_index').is(':hidden')) {
		item = $('#fuel_index');
	}
	if (!$('#fuel_new').is(':hidden')) {
		item = $('#fuel_new');
	}
	if (!$('#fuel_edit').is(':hidden')) {
		item = $('#fuel_edit');
	}
	item.fadeOut(300, function() {
		$('#fuel_edit').fadeIn(300);
	});
	$.ajax({
		url: 'http://localhost:3000/api/fuels/' + id,
		type: 'get',
		complete: function(xhr) {
			if (xhr.status == 200) {
				$('#fuel_edit [name="[unit]"]').val(String(xhr.responseJSON.unit));
				$('#fuel_edit [name="[number]"]').val(String(xhr.responseJSON.number));
				$('#fuel_edit [name="[name]"]').val(String(xhr.responseJSON.name));
				$('#fuel_edit [name="[address]"]').val(String(xhr.responseJSON.address));
				$('#fuel_edit [name="[balance]"]').val(String(xhr.responseJSON.balance));
				$('#fuel_edit [name="id"]').val(String(xhr.responseJSON.id));
			} else {
				alert('获取账户失败！\n' + xhr.responseText);
			}
      // {
      //  "readyState":4,
      //  "responseText":"{\"success\":\"测试成功\"}",
      //  "responseJSON":{"success":"测试成功"},
      //  "status":200,
      //  "statusText":"OK"
      // }
    },
  });
}
function updateFuel(form) {
	id = $('#fuel_edit [name="id"]').val();
	$.ajax({
		url: 'http://localhost:3000/api/fuels/' + id,
		type: 'patch',
		data: $(form).serialize(),
		complete: function(xhr) {
			if (xhr.status == 200) {
				alert('修改账户成功！\n' + xhr.responseText);
				window.location.href="/fuels"; 
			} else {
				alert('修改账户失败！\n' + xhr.responseText);
			}
      // {
      //  "readyState":4,
      //  "responseText":"{\"success\":\"测试成功\"}",
      //  "responseJSON":{"success":"测试成功"},
      //  "status":200,
      //  "statusText":"OK"
      // }
    },
  });

	return false;
}

// 检索账户
function searchFuel(form) {
	$.ajax({
		url: 'http://localhost:3000/api/fuels/search',
		type: 'get',
		data: $(form).serialize(),
		complete: function(xhr) {
			if (xhr.status == 200) {
				if (!$('#fuel_index').is(':hidden')) {
					item = $('#fuel_index');
				}
				if (!$('#fuel_new').is(':hidden')) {
					item = $('#fuel_new');
				}
				if (!$('#fuel_edit').is(':hidden')) {
					item = $('#fuel_edit');
				}
				item.fadeOut(300, function() {
					$('#fuel_edit').fadeIn(300);
				});
				$('#fuel_edit [name="[unit]"]').val(String(xhr.responseJSON.unit));
				$('#fuel_edit [name="[number]"]').val(String(xhr.responseJSON.number));
				$('#fuel_edit [name="[name]"]').val(String(xhr.responseJSON.name));
				$('#fuel_edit [name="[address]"]').val(String(xhr.responseJSON.address));
				$('#fuel_edit [name="[balance]"]').val(String(xhr.responseJSON.balance));
				$('#fuel_edit [name="id"]').val(String(xhr.responseJSON.id));
			} else {
				alert('检索账户失败！\n' + xhr.responseText);
			}
      // {
      //  "readyState":4,
      //  "responseText":"{\"success\":\"测试成功\"}",
      //  "responseJSON":{"success":"测试成功"},
      //  "status":200,
      //  "statusText":"OK"
      // }
    },
  });

	return false;
}

// 删除账户
function destroyFuel(id) {
	if (!confirm('确认删除吗？')) {
		return false;
	}

	$.ajax({
		url: 'http://localhost:3000/api/fuels/' + id,
		type: 'delete',
		complete: function(xhr) {
			if (xhr.status == 200) {
				alert('删除账户成功！\n' + xhr.responseText);
				window.location.href="/fuels"; 
			} else {
				alert('删除账户失败！\n' + xhr.responseText);
			}
      // {
      //  "readyState":4,
      //  "responseText":"{\"success\":\"测试成功\"}",
      //  "responseJSON":{"success":"测试成功"},
      //  "status":200,
      //  "statusText":"OK"
      // }
    },
  });
}

// 取消操作
function cancelFuel(ori) {
	if (ori == 'new') {
		opt = '#fuel_new';
	} else {
		opt = '#fuel_edit';
	}

	$(opt).fadeOut(300, function() {
		$('#fuel_index').fadeIn(300);
	});
}

// 匹配
function matchFuel(form) {
	$.ajax({
		url: 'http://localhost:3000/api/fuels/match',
		type: 'get',
		data: $(form).serialize(),
		complete: function(xhr) {
			if (xhr.status == 200) {
				$('#fuel_match').fadeOut(300, function() {
					$('#Infdisplay').fadeIn(300);
				});

				// alert(JSON.stringify(xhr));
				$('#fuel_unit').val(String(xhr.responseJSON.unit));
				$('#fuel_number').val(String(xhr.responseJSON.number));
				$('#fuel_name').val(String(xhr.responseJSON.name));
				$('#fuel_address').val(String(xhr.responseJSON.address));
				$('#fuel_balance').val(String(xhr.responseJSON.balance));
				$('#pay_id').val(String(xhr.responseJSON.id));

				$('#fuel_unit').attr('disabled', 'disabled');
				$('#fuel_number').attr('disabled', 'disabled');
				$('#fuel_name').attr('disabled', 'disabled');
				$('#fuel_address').attr('disabled', 'disabled');
				$('#fuel_balance').attr('disabled', 'disabled');
			} else {
				alert('查找账户失败！\n' + xhr.responseText);
			}
    },
  });

	return false;
}

// 支付
function payFuel(form) {
	if (!confirm('现在去付款？')) {
		return false;
	}

	$.ajax({
		url: 'http://localhost:3000/api/fuels/pay',
		type: 'patch',
		data: $(form).serialize(),
		complete: function(xhr) {
			if (xhr.status == 200) {
				alert('缴费成功！\n' + xhr.responseText);
			} else {
				alert('缴费失败！\n' + xhr.responseText);
			}
		},
	});
	return false;
}

// 快捷支付
function quickpayFuel(form) {
	if (!confirm('现在去付款？')) {
	  return false;
	}

	$.ajax({
	  url: 'http://localhost:3000/api/fuels/quickpay',
	  type: 'patch',
	  data: $(form).serialize(),
	  complete: function(xhr) {
	    if (xhr.status == 200) {
				alert('快速缴费成功！\n' + xhr.responseText);
	    } else {
				alert('快速缴费失败！\n' + xhr.responseText);
	    }
	  },
	});
	return false;
}