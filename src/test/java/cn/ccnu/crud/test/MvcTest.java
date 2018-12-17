package cn.ccnu.crud.test;

import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import cn.ccnu.crud.bean.Employee;

import com.github.pagehelper.PageInfo;

/**
 * 使用Spring测试模块提供的-测试请求功能，测试curd请求的正确性；
 * 注意：Spring4测试MVC请求的时候，需要servlet3.0的支持
 * 
 * @author William Python
 *
 */
@RunWith(SpringJUnit4ClassRunner.class)
// 加上后还可以拿到Spring容器本身
@WebAppConfiguration
@ContextConfiguration(locations = { "classpath:applicationContext.xml",
		"classpath:spring-mvc.xml" })
public class MvcTest {
	// 传入Springmvc的ioc
	@Autowired
	WebApplicationContext context;
	// 虚拟mvc请求，获取到处理结果
	MockMvc mockMvc;

	@Before
	public void initMokcMvc() {
		mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
	}

	/**
	 * 测试普通分页查询（已过时）
	 * @throws Exception
	 */
	@Test
	public void testPage() throws Exception {
		// 模拟请求拿到返回值
		MvcResult result = mockMvc.perform(
				MockMvcRequestBuilders.get("/emps").param("pn", "5"))
				.andReturn();
		// 请求成功以后，请求域中会有pageInfo；我们可以取出pageInfo进行验证
		MockHttpServletRequest request = result.getRequest();
		PageInfo<Employee> pi = (PageInfo<Employee>) request
				.getAttribute("pageInfo");
		System.out.println("当前页码：" + pi.getPageNum());
		System.out.println("总页码：" + pi.getPages());
		System.out.println("总记录数：" + pi.getTotal());
		System.out.println("在页面需要连续显示的页码：");
		int[] nums = pi.getNavigatepageNums();
		for (int i : nums) {
			System.out.print(" " + i);
		}
		System.out.println();

		// 获取员工数据
		List<Employee> list = pi.getList();
		for (Employee employee : list) {
			System.out.println("ID：" + employee.getEmpId() + "==>Name:"
					+ employee.getEmpName());
		}

	}
}
