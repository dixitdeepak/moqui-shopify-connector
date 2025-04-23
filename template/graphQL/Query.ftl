<#assign ObjectUtilities = Static["org.moqui.util.ObjectUtilities"]/>

<@renderQuery operation=payload.operation name=payload.name variables=payload.variables! entity=payload.entity alias=payload.alias! args=payload.args! fields=payload.fields />

<#macro renderQuery operation name variables entity alias args fields>
  ${operation}<#if name??> ${name}</#if><#if variables?? && variables?size &gt; 0>( <#list variables as v>${v.name}: ${v.type}<#if v_has_next>, </#if></#list>)</#if> {
    <@renderEntity entity=entity alias=alias args=args fields=fields />
  }
</#macro>

<#macro renderEntity entity fields alias="" args="">
  <#if alias?has_content>${alias}: </#if>${entity}<#if args?has_content>(${args})</#if> {
  <#list fields as field>
    <#if ObjectUtilities.isInstanceOf(field, "List") || ObjectUtilities.isInstanceOf(field, "Map")>
      <#if field.nodeFields??>
      edges {
        node {
          <#list field.nodeFields as nf>
            <#if ObjectUtilities.isInstanceOf(nf, "Map")>
              <#if nf.entity??>
                <@renderEntity entity=nf.entity alias=nf.alias args=nf.args fields=nf.fields />
              </#if>
            <#elseif nf?is_string>
              ${nf}
            </#if>
          </#list>
        }
      }
      pageInfo {
        hasNextPage
        hasPreviousPage
        startCursor
        endCursor
      }
      <#elseif field.fragment??>
      ...${field.fragment}
      <#elseif field.entity??>
      <@renderEntity entity=field.entity alias=field.alias args=field.args fields=field.fields />
      </#if>
    <#elseif field?is_string>
      ${field}
    </#if>
  </#list>
  }
</#macro>