package com.customerissue.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;
import java.util.List;

/**
 * 分类实体
 * 
 * @author Customer Issue System
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName("categories")
@Schema(description = "分类信息")
public class Category extends BaseEntity {

    @Schema(description = "分类名称", requiredMode = Schema.RequiredMode.REQUIRED)
    @NotBlank(message = "分类名称不能为空")
    @Size(max = 100, message = "分类名称长度不能超过100个字符")
    @TableField("name")
    private String name;

    @Schema(description = "父分类ID")
    @TableField("parent_id")
    private Long parentId;

    @Schema(description = "分类描述")
    @TableField("description")
    private String description;

    @Schema(description = "排序")
    @TableField("sort_order")
    private Integer sortOrder;

    // 扩展字段，不存储到数据库
    @Schema(description = "父分类名称")
    @TableField(exist = false)
    private String parentName;

    @Schema(description = "子分类列表")
    @TableField(exist = false)
    private List<Category> children;

    @Schema(description = "问题数量")
    @TableField(exist = false)
    private Integer issueCount;
} 